//
//  WelcomeViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 02.03.2026.
//

import UIKit

final class WelcomeViewController: UIViewController, WelcomeView {
    private let presenter: WelcomePresenter

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TOTPly"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.accessibilityIdentifier = "welcome.title"
        return label
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        button.accessibilityIdentifier = "welcome.signIn"
        return button
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать аккаунт", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        button.accessibilityIdentifier = "welcome.createAccount"
        return button
    }()

    init(presenter: WelcomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(createAccountButton)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
        presenter.viewDidLoad()
    }

    func render(_ state: WelcomeViewState) {
        // статичное вью
    }

    @objc private func didTapSignIn() {
        presenter.didTapSignIn()
    }

    @objc private func didTapCreateAccount() {
        presenter.didTapCreateAccount()
    }
}
