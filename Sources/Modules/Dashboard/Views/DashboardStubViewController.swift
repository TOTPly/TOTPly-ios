//
//  DashboardStubViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class DashboardStubViewController: UIViewController {
    private let label: UILabel = {
        let l = UILabel()
        l.text = "Тут будет главный дэшборд"
        l.font = .systemFont(ofSize: 20, weight: .medium)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
