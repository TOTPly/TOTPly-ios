//
//  RegistrationViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class RegistrationViewController: UIViewController, RegistrationView {
    private let presenter: RegistrationPresenter

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
        l.text = "Регистрация"
        l.font = .systemFont(ofSize: 24, weight: .bold)
        return l
    }()

    private let emailField: UITextField = {
        let t = UITextField()
        t.placeholder = "Почта"
        t.keyboardType = .emailAddress
        t.autocapitalizationType = .none
        t.borderStyle = .roundedRect
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

    private let confirmPasswordField: UITextField = {
        let t = UITextField()
        t.placeholder = "Повторите пароль"
        t.isSecureTextEntry = true
        t.borderStyle = .roundedRect
        return t
    }()

    private let confirmPasswordErrorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private let displayNameField: UITextField = {
        let t = UITextField()
        t.placeholder = "Имя"
        t.borderStyle = .roundedRect
        return t
    }()

    private let displayNameErrorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Зарегистрироваться", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.isEnabled = false
        return b
    }()

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Уже есть аккаунт? Войти", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15)
        return b
    }()

    init(presenter: RegistrationPresenter) {
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
        stackView.addArrangedSubview(displayNameField)
        stackView.addArrangedSubview(displayNameErrorLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(emailErrorLabel)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(passwordErrorLabel)
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.addArrangedSubview(confirmPasswordErrorLabel)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(loginButton)

        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        displayNameField.addTarget(self, action: #selector(displayNameChanged), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapGoToLogin), for: .touchUpInside)
        
        displayNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self

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
        guard let userInfo = note.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardInView)
        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }

    func render(_ state: RegistrationViewState) {
        let showDisplayNameError = state.validationErrors.displayNameError != nil && state.displayNameTouched
        let showEmailError = state.validationErrors.emailError != nil && state.emailTouched
        let showPasswordError = state.validationErrors.passwordError != nil && state.passwordTouched
        let showConfirmPasswordError = state.validationErrors.confirmPasswordError != nil && state.confirmPasswordTouched
        
        displayNameErrorLabel.text = state.validationErrors.displayNameError
        displayNameErrorLabel.isHidden = !showDisplayNameError

        emailErrorLabel.text = state.validationErrors.emailError
        emailErrorLabel.isHidden = !showEmailError

        passwordErrorLabel.text = state.validationErrors.passwordError
        passwordErrorLabel.isHidden = !showPasswordError

        confirmPasswordErrorLabel.text = state.validationErrors.confirmPasswordError
        confirmPasswordErrorLabel.isHidden = !showConfirmPasswordError

        applyValidationStyle(textField: displayNameField, hasError: showDisplayNameError)
        applyValidationStyle(textField: emailField, hasError: showEmailError)
        applyValidationStyle(textField: passwordField, hasError: showPasswordError)
        applyValidationStyle(textField: confirmPasswordField, hasError: showConfirmPasswordError)

        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
        registerButton.isEnabled = state.isRegisterButtonEnabled && !state.isLoading
        if state.isLoading {
            registerButton.setTitle("Регистрация…", for: .normal)
        } else {
            registerButton.setTitle("Зарегистрироваться", for: .normal)
        }
    }

    @objc private func emailChanged() {
        presenter.didChangeEmail(emailField.text ?? "")
    }
    
    @objc private func passwordChanged() {
        presenter.didChangePassword(passwordField.text ?? "")
    }

    @objc private func confirmPasswordChanged() {
        presenter.didChangeConfirmPassword(confirmPasswordField.text ?? "")
    }

    @objc private func displayNameChanged() {
        presenter.didChangeDisplayName(displayNameField.text ?? "")
    }

    @objc private func didTapRegister() {
        view.endEditing(true) // скрыли клавиатуру
        presenter.didTapRegister(
            email: emailField.text ?? "",
            password: passwordField.text ?? "",
            confirmPassword: confirmPasswordField.text ?? "",
            displayName: displayNameField.text?.isEmpty == false ? displayNameField.text : nil
        )
    }

    @objc private func didTapGoToLogin() {
        presenter.didTapGoToLogin()
    }

    private func applyValidationStyle(textField: UITextField, hasError: Bool) {
        if hasError {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemRed.cgColor
            textField.layer.cornerRadius = 8
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === displayNameField {
            emailField.becomeFirstResponder()
        } else if textField === emailField {
            passwordField.becomeFirstResponder()
        } else if textField === passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if registerButton.isEnabled {
                didTapRegister()
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === displayNameField {
            presenter.didEndEditingDisplayName()
        } else if textField === emailField {
            presenter.didEndEditingEmail()
        } else if textField === passwordField {
            presenter.didEndEditingPassword()
        } else if textField === confirmPasswordField {
            presenter.didEndEditingConfirmPassword()
        }
    }
}
