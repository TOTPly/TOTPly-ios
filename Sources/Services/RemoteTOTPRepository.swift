//
//  RemoteTOTPRepository.swift
//  TOTPly-ios
//
//  Created by Matthew on 10.03.2026.
//

import Foundation

final class RemoteTOTPRepository: TOTPRepository {
    private let networkClient: NetworkClient
    private let storage: StorageService
    private let baseURL: String
    private let echoPath: String
    
    private let cacheTTL: TimeInterval = 30 * 60
    private var lastSyncDate: Date?
    
    private let useMockData: Bool
    
    init(
        networkClient: NetworkClient,
        storage: StorageService,
        baseURL: String = "https://alfaitmo.ru/server/echo",
        echoPath: String = "471057/totply-ios/items",
        useMockData: Bool = false
    ) {
        self.networkClient = networkClient
        self.storage = storage
        self.baseURL = baseURL
        self.echoPath = echoPath
        self.useMockData = useMockData
    }
    
    private func saveItemsToLocalStorage(_ items: [TOTPItem]) throws {
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    
    func fetchRemoteItems() async throws -> [TOTPItem] {
        if useMockData {
            print("Using mock data")
            return createMockItems()
        }
        
        if let cachedItems = try? await fetchLocalItems(),
           !cachedItems.isEmpty,
           let lastSync = lastSyncDate,
           Date().timeIntervalSince(lastSync) < cacheTTL {
            return cachedItems
        }
        
        do {

            guard let url = URL(string: "\(baseURL)/\(echoPath)") else {
                throw NetworkError.invalidResponse
            }
            
            let response: TOTPItemsResponse = try await networkClient.get(url)
            
            // Маппим DTO в domain модели
            // Пока если хотя бы один элемент невалиден то бросим ошибку
            let items = try response.items.map { try $0.toDomain() }
            
            lastSyncDate = Date()
            
            try saveItemsToLocalStorage(items)
            
            return items
        } catch {
            // Graceful degradation: если сеть недоступна, используем устаревший кэш, с секретами это ок
            if let staleCachedItems = try? await fetchLocalItems(), !staleCachedItems.isEmpty {
                if let lastSync = lastSyncDate {
                    let cacheAge = Date().timeIntervalSince(lastSync)
                    print("Network error, using stale cache (age: \(Int(cacheAge))s)")
                } else {
                    print("Network error, using old cache (unknown age)")
                }
                return staleCachedItems
            }
            
            // а вот если кэша нет то грустно
            throw error
        }
    }
    
    func fetchLocalItems() async throws -> [TOTPItem] {
        // грузим из локального кейчейна
        guard let items: [TOTPItem] = try storage.load(key: StorageKey.totpItems.rawValue) else {
            return []
        }
        return items.filter { !$0.isDeleted }
    }
    
    func saveItem(_ item: TOTPItem) async throws {
        // Пока сохраняем только локально
        var items = try await fetchLocalItems()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    func deleteItem(id: String) async throws {
        // Пока помечаем как удалённый локально
        var items = try await fetchLocalItems()
        if let index = items.firstIndex(where: { $0.id == id }) {
            let item = items[index]
            items[index] = TOTPItem(
                id: item.id,
                name: item.name,
                issuer: item.issuer,
                secret: item.secret,
                algorithm: item.algorithm,
                digits: item.digits,
                period: item.period,
                createdAt: item.createdAt,
                updatedAt: Date(),
                isDeleted: true,
                syncedAt: item.syncedAt
            )
        }
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    func invalidateCache() {
        lastSyncDate = nil
        
        // можно явно удалить?
    }
    
    private func createMockItems() -> [TOTPItem] {
        if let items = loadMockItemsFromJSON() {
            print("Loaded \(items.count) mock items from JSON")
            return items
        }
        
        print("something went wrong")
        return []
    }
    
    private func loadMockItemsFromJSON() -> [TOTPItem]? {
        guard let url = Bundle.main.url(forResource: "mock_totp_items", withExtension: "json") else {
            print("mock_totp_items.json not found in bundle")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MockTOTPItemsResponse.self, from: data)
            
            let now = Date()
            return response.items.map { dto in
                TOTPItem(
                    id: dto.id,
                    name: dto.name,
                    issuer: dto.issuer,
                    secret: dto.secret,
                    algorithm: TOTPAlgorithm(rawValue: dto.algorithm) ?? .sha1,
                    digits: dto.digits,
                    period: dto.period,
                    createdAt: now.addingTimeInterval(-86400 * 7),
                    updatedAt: now.addingTimeInterval(-3600),
                    isDeleted: false,
                    syncedAt: now
                )
            }
        } catch {
            print("Failed to decode mock_totp_items.json: \(error)")
            return nil
        }
    }
}

private struct MockTOTPItemsResponse: Decodable {
    let items: [MockTOTPItemDTO]
}

private struct MockTOTPItemDTO: Decodable {
    let id: String
    let name: String
    let issuer: String
    let secret: String
    let algorithm: String
    let digits: Int
    let period: Int
}
