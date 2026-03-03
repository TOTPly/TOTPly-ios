//
//  LoginPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import Foundation

final class LoginPresenterImpl: LoginPresenter {
    private weak var view: LoginView?
    private let router: AuthRouter
    private let authRepository: AuthRepository

    private var state: LoginViewState = .initial {
        didSet { view?.render(state) } // property observer
    }

    init(router: AuthRouter, authRepository: AuthRepository) {
        self.router = router
        self.authRepository = authRepository
    }

    func setView(_ view: LoginView) {
        self.view = view
    }

    func viewDidLoad() {
        state = .initial
        view?.render(state)
    }

    func didTapLogin(email: String, password: String) {
        state.loadingState = .loading
        state.validationErrors = .init()  // красиво
        view?.render(state)
        
        
        // @objc didTapLogin() внутри view не поддерживает async
        Task { @MainActor in // принудительно возвращает в главный после async
            do {
                // происходит в фоновом потоке и не гарантирует возвращение в главны
                let result = try await authRepository.login(email: email, password: password)
                switch result {
                case .session:
                    router.openDashboard()
                case .requiresEmailVerification(let email):
                    state.loadingState = .initial
                    state.showVerificationPrompt = true // с этим ещё нужно подумать...
                    state.validationErrors = .init()
                    view?.render(state)
                    router.openEmailVerification(email: email, type: .login)
                }
            } catch {
                state.loadingState = .error(AppError.authError(error as? AuthError ?? .invalidCredentials))
                state.validationErrors = .init()
                view?.render(state)
            }
        }
    }

    func didTapForgotPassword() {
        router.openPasswordRecovery()
    }

    func didTapResendVerification(email: String) {
        router.openEmailVerification(email: email, type: .login)
    }

    func didTapGoToRegister() {
        router.openRegistration()
    }

    func didChangeEmail(_ email: String) {
        state.email = email
        state.isLoginButtonEnabled = !email.isEmpty && !state.password.isEmpty
        state.validationErrors.emailError = nil
        view?.render(state)
    }

    func didChangePassword(_ password: String) {
        state.password = password
        state.isLoginButtonEnabled = !state.email.isEmpty && !password.isEmpty
        state.validationErrors.passwordError = nil
        view?.render(state)
    }
}
