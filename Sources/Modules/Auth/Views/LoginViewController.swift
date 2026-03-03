//
//  LoginViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class LoginViewController: UIViewController, LoginView {
    private let presenter: LoginPresenter

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.keyboardDismissMode = .onDrag
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 16
        s.alignment = .fill
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Вход"
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.accessibilityIdentifier = "login.title"
        return l
    }()

    private let emailField: UITextField = {
        let t = UITextField()
        t.placeholder = "Почта"
        t.keyboardType = .emailAddress
        t.autocapitalizationType = .none
        t.autocorrectionType = .no
        t.borderStyle = .roundedRect
        t.accessibilityIdentifier = "login.email"
        return t
    }()

    private let emailErrorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private let passwordField: UITextField = {
        let t = UITextField()
        t.placeholder = "Пароль"
        t.isSecureTextEntry = true
        t.borderStyle = .roundedRect
        t.accessibilityIdentifier = "login.password"
        return t
    }()

    private let passwordErrorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        l.accessibilityIdentifier = "login.error"
        return l
    }()

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Войти", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.isEnabled = false
        b.accessibilityIdentifier = "login.submit"
        return b
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Нет аккаунта? Регистрация", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15)
        b.accessibilityIdentifier = "login.goToRegister"
        return b
    }()

    private var loginButtonBottomConstraint: NSLayoutConstraint?

    init(presenter: LoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(emailErrorLabel)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(passwordErrorLabel)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(registerButton)

        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        emailField.delegate = self    // ниже - привязываем textFieldShouldReturn из протокола UITextFieldDelegate
        passwordField.delegate = self
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapGoToRegister), for: .touchUpInside)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])

        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrame(_ note: Notification) {
        guard
            let userInfo = note.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let keyboardInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardInView)
        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }

    func render(_ state: LoginViewState) {
        emailErrorLabel.text = state.validationErrors.emailError
        emailErrorLabel.isHidden = state.validationErrors.emailError == nil
        passwordErrorLabel.text = state.validationErrors.passwordError
        passwordErrorLabel.isHidden = state.validationErrors.passwordError == nil
        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
        loginButton.isEnabled = state.isLoginButtonEnabled && !state.isLoading
        if state.isLoading {
            loginButton.setTitle("Вход…", for: .normal)
        } else {
            loginButton.setTitle("Войти", for: .normal)
        }
    }

    @objc private func emailChanged() {
        presenter.didChangeEmail(emailField.text ?? "")
    }

    @objc private func passwordChanged() {
        presenter.didChangePassword(passwordField.text ?? "")
    }

    @objc private func didTapLogin() {
        view.endEditing(true)
        presenter.didTapLogin(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    @objc private func didTapGoToRegister() {
        presenter.didTapGoToRegister()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if loginButton.isEnabled {
                didTapLogin()
            }
        }
        return true
    }
}
