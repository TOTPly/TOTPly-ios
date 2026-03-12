//
//  DashboardStubViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class DashboardStubViewController: UIViewController {
    var presenter: DashboardPresenter?
    
    private let label: UILabel = {
        let l = UILabel()
        l.text = "Загрузка..."
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Dashboard"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(didTapRefresh)
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // нет горизонтального скролла
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        
        presenter?.viewDidLoad()
    }
    
    @objc private func didTapRefresh() {
        presenter?.didPullToRefresh()
    }
}


extension DashboardStubViewController: DashboardView {
    func render(_ state: DashboardViewState) {
        var text = "Dashboard State Debug\n\n"
        
        switch state.loadingState {
        case .initial:
            text += " State: Initial\n\n"
        case .loading:
            text += " State: Loading...\n\n"
        case .loaded:
            text += " State: Loaded\n\n"
        case .error(let error):
            text += " State: Error\n\(error.localizedDescription)\n\n"
        }
        
        text += " Количество items: \(state.items.count)\n"
        
        if !state.searchQuery.isEmpty {
            text += " Поиск: \"\(state.searchQuery)\"\n"
            text += " Фильтр: \(state.filteredItems.count)\n"
        }
        
        text += "\n"
        
        if state.items.isEmpty {
            text += "Нет данных\n"
        } else {
            for (index, item) in state.displayItems.enumerated() {
                text += "[\(index + 1)] \(item.displayName)\n"
                if let issuer = item.issuer {
                    text += "    Issuer: \(issuer)\n"
                }
                text += "    Code: \(state.areCodesMasked ? "••••••" : item.currentCode)\n"
                text += "    Expires in: \(item.timeRemaining)s\n"
                text += "\n"
            }
        }
        
        label.text = text
    }
    
    func copyCodeToClipboard(_ code: String) {
        UIPasteboard.general.string = code
        
//        // Haptic feedback?
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
        
        // TODO внизу экрана показать что скопировали успешно
    }
}
