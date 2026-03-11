//
//  RegistrationPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import Foundation

final class RegistrationPresenterImpl: RegistrationPresenter {
    private weak var view: RegistrationView?
    private let router: AuthRouter
    private let authRepository: AuthRepository

    private var state: RegistrationViewState = .initial {
        didSet { view?.render(state) }
    }

    init(router: AuthRouter, authRepository: AuthRepository) {
        self.router = router
        self.authRepository = authRepository
    }

    func setView(_ view: RegistrationView) {
        self.view = view
    }

    func viewDidLoad() {
        state = .initial
        view?.render(state)
    }

    func didTapRegister(email: String, password: String, confirmPassword: String, displayName: String?) {
        state.email = email
        state.password = password
        state.confirmPassword = confirmPassword
        state.displayName = displayName ?? ""
        state.emailTouched = true
        state.passwordTouched = true
        state.confirmPasswordTouched = true
        state.displayNameTouched = true
        validateFields()

        guard
            state.validationErrors.emailError == nil,
            state.validationErrors.passwordError == nil,
            state.validationErrors.confirmPasswordError == nil,
            state.validationErrors.displayNameError == nil
        else {
            return
        }

        state.loadingState = .loading
        state.validationErrors = .init()
        view?.render(state)

        Task { @MainActor in
            do {
                let result = try await authRepository.register(email: email, password: password, displayName: displayName)
                switch result {
                case .session:
                    router.openDashboard()
                case .requiresEmailVerification(let email):
                    state.loadingState = .initial
                    view?.render(state)
                    router.openEmailVerification(email: email, type: .registration)
                }
            } catch {
                state.loadingState = .error(AppError.authError(error as? AuthError ?? .invalidCredentials))
                view?.render(state)
            }
        }
    }

    func didTapGoToLogin() {
        router.goBackToLogin()
    }

    func didChangeEmail(_ email: String) {
        state.email = email
        validateFields()
        view?.render(state)
    }

    func didChangePassword(_ password: String) {
        state.password = password
        validateFields()
        view?.render(state)
    }

    func didChangeConfirmPassword(_ confirmPassword: String) {
        state.confirmPassword = confirmPassword
        state.confirmPasswordTouched = true // тут сразу
        validateFields()
        view?.render(state)
    }

    func didChangeDisplayName(_ displayName: String) {
        state.displayName = displayName
        validateFields()
        view?.render(state)
    }

    func didEndEditingEmail() {
        state.emailTouched = true
        validateFields()
        view?.render(state)
    }

    func didEndEditingPassword() {
        state.passwordTouched = true
        validateFields()
        view?.render(state)
    }

    func didEndEditingConfirmPassword() {
        state.confirmPasswordTouched = true
        validateFields()
        view?.render(state)
    }

    func didEndEditingDisplayName() {
        state.displayNameTouched = true
        validateFields()
        view?.render(state)
    }

    private func validateFields() {
        var errors = RegistrationViewState.ValidationErrors()

        let trimmedEmail = state.email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            errors.emailError = "Введите почту"
        } else if !isValidEmail(trimmedEmail) {
            errors.emailError = "Некорректная почта"
        }

        if state.password.isEmpty {
            errors.passwordError = "Введите пароль"
        } else if let strengthError = passwordStrengthError(state.password) {
            errors.passwordError = strengthError
        }

        if state.confirmPassword.isEmpty {
            errors.confirmPasswordError = "Повторите пароль"
        } else if state.confirmPassword != state.password {
            errors.confirmPasswordError = "Пароли не совпадают"
        }

        let trimmedName = state.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            errors.displayNameError = "Введите имя"
        } else if trimmedName.count < 2 {
            errors.displayNameError = "Слишком короткое имя"
        }

        state.validationErrors = errors
        state.isRegisterButtonEnabled = errors.emailError == nil &&
            errors.passwordError == nil &&
            errors.confirmPasswordError == nil &&
            errors.displayNameError == nil
    }

    private func passwordStrengthError(_ password: String) -> String? {
        var requirements: [String] = []
        if password.count < 8 { requirements.append("минимум 8 символов") }
        if !password.contains(where: { $0.isUppercase }) { requirements.append("есть заглавная буква") }
        if !password.contains(where: { $0.isLowercase }) { requirements.append("есть строчная буква") }
        if !password.contains(where: { $0.isNumber }) { requirements.append("есть цифра") }
        let special = CharacterSet.alphanumerics.inverted
        if !password.unicodeScalars.contains(where: { special.contains($0) }) { requirements.append("есть спецсимвол") }
        guard !requirements.isEmpty else { return nil }
        return "Пароль не соответствует требованиям: " + requirements.joined(separator: ", ")
    }

    private func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@")
        guard parts.count == 2, !parts[0].isEmpty else { return false }
        let domainParts = parts[1].split(separator: ".")
        guard domainParts.count >= 2, !domainParts.last!.isEmpty else { return false }
        return true
    }
}
