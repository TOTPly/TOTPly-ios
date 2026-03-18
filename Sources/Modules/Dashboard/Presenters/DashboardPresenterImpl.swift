//
//  DashboardPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 11.03.2026.
//

import Foundation

final class DashboardPresenterImpl: DashboardPresenter {
    private weak var view: DashboardView?
    private let repository: TOTPRepository
    private let generator: TOTPGenerator
    private let router: DashboardRouter
    
    private var state: DashboardViewState = .initial

    private var loadItemsTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?

    private var rawItems: [TOTPItem] = []
    private var codeTimer: Timer?
    
    init(
        view: DashboardView,
        repository: TOTPRepository,
        generator: TOTPGenerator,
        router: DashboardRouter
    ) {
        self.view = view
        self.repository = repository
        self.generator = generator
        self.router = router
    }
    
    
    func viewDidLoad() {
        loadItems()
        startTimer()
    }

    func viewWillAppear() {
        refreshItems()
    }

    private func startTimer() {
        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.regenerateCodes()
        }
        RunLoop.main.add(timer, forMode: .common)
        codeTimer = timer
    }

    private func regenerateCodes() {
        guard !rawItems.isEmpty else { return }

        let viewModels = rawItems.compactMap { DashboardTOTPItem.from(item: $0, generator: generator) }
        state.items = viewModels

        if !state.searchQuery.isEmpty {
            didSearch(query: state.searchQuery)
        } else {
            render()
        }
    }
    
    func didPullToRefresh() {
        loadItemsTask?.cancel()
        
        state.isRefreshing = true
        render()
        
        loadItemsTask = Task { @MainActor in
            await loadItemsFromRemote()
            state.isRefreshing = false
            render()
        }
    }
    
    func didTapItem(at index: Int) {
        let items = state.displayItems
        
        let item = items[index]
        router.openCodeDetail(itemId: item.id)
    }
    
    func didTapAddNew() {
        router.openAddTOTP()
    }
    
    func didTapSettings() {
        router.openSettings()
    }
    
    func didTapProfile() {
        router.openProfile()
    }
    
    func didTapCopyCode(itemId: String) {
        guard let item = state.items.first(where: { $0.id == itemId }) else {
            return
        }
        
        // Делегируем копирование и фидбек вьюшке
        view?.copyCodeToClipboard(item.currentCode)
    }
    
    func didSearch(query: String) {
        state.searchQuery = query
        
        if query.isEmpty {
            state.filteredItems = []
        } else {
            let lowercasedQuery = query.lowercased()
            state.filteredItems = state.items.filter {
                $0.displayName.lowercased().contains(lowercasedQuery) ||
                ($0.issuer?.lowercased().contains(lowercasedQuery) ?? false)
            }
        }
        
        render()
    }
    
    func didTapDelete(itemId: String) {
        Task { @MainActor in
            do {
                try await repository.deleteItem(id: itemId)
                await loadItemsFromLocal()
            } catch {
                handleError(error)
            }
        }
    }
    
    func didTapToggleCodeMask() {
        state.areCodesMasked.toggle()
        render()
    }
    
    func didTapForceRefresh() {
        repository.invalidateCache()
        didPullToRefresh()
    }
    
    
    private func loadItems() {
        loadItemsTask?.cancel()
        
        state.loadingState = .loading
        render()
        
        loadItemsTask = Task { @MainActor in
            await loadItemsFromRemote()
        }
    }
    
    private func refreshItems() {
        refreshTask?.cancel()
        
        refreshTask = Task { @MainActor in
            // Сначала показываем локальные данные
            await loadItemsFromLocal()
            
            // Затем загружаем с сервера
            await loadItemsFromRemote()
        }
    }
    
    private func loadItemsFromRemote() async {
        do {
            if Task.isCancelled { return }
            
            let totpItems = try await repository.fetchRemoteItems()

            if Task.isCancelled { return }

            let viewModels = totpItems.compactMap { DashboardTOTPItem.from(item: $0, generator: generator) }

            if Task.isCancelled { return }

            await MainActor.run {
                // Обновляем только если данные изменились
                guard state.items != viewModels else {
                    state.loadingState = .loaded
                    return
                }

                rawItems = totpItems
                state.items = viewModels
                state.loadingState = .loaded
                
                // Обновляем фильтрованные результаты если есть поиск
                if !state.searchQuery.isEmpty {
                    didSearch(query: state.searchQuery)
                } else {
                    render()
                }
            }
        } catch {
            if Task.isCancelled { return }
            
            await MainActor.run {
                handleError(error)
            }
        }
    }
    
    private func loadItemsFromLocal() async {
        do {
            if Task.isCancelled { return }
            
            let totpItems = try await repository.fetchLocalItems()

            if Task.isCancelled { return }

            let viewModels = totpItems.compactMap { DashboardTOTPItem.from(item: $0, generator: generator) }

            if Task.isCancelled { return }

            await MainActor.run {
                // Обновляем только если данные изменились
                guard state.items != viewModels else {
                    state.loadingState = .loaded
                    return
                }

                rawItems = totpItems
                state.items = viewModels
                state.loadingState = .loaded
                render()
            }
        } catch let error as KeychainStorageError {
            // Keychain недоступен - проблемы с подписью и т.д.
            await MainActor.run {
                print("[WARNING] Keychain storage error: \(error)")
                // Не критично - данные загрузятся с сервера
            }
        } catch is DecodingError {
            // Данные в Keychain повреждены или несовместимая версия
            await MainActor.run {
                print("[WARNING] Failed to decode local items - data might be corrupted")
                // Не критично - данные загрузятся с сервера
            }
        } catch {
            await MainActor.run {
                print("[WARNING] Unexpected error loading local items: \(error)")
                // Не критично - данные загрузятся с сервера
            }
        }
    }
    
    private func handleError(_ error: Error) {
        let appError: AppError
        
        if let networkError = error as? NetworkError {
            appError = .networkError(networkError)
        } else {
            appError = .unknown(error.localizedDescription)
        }
        
        state.loadingState = .error(appError)
        render()
    }
    
    private func render() {
        view?.render(state)
    }
}
