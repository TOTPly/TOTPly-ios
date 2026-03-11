//
//  LoginViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct LoginViewState: Equatable {
    var loadingState: LoadingState
    var email: String
    var password: String
    var validationErrors: ValidationErrors
    var emailTouched: Bool
    var passwordTouched: Bool
    var isLoginButtonEnabled: Bool
    var showVerificationPrompt: Bool

    struct ValidationErrors: Equatable {
        var emailError: String?
        var passwordError: String?
    }

    static var initial: LoginViewState {
        LoginViewState(
            loadingState: .initial,
            email: "",
            password: "",
            validationErrors: ValidationErrors(),
            emailTouched: false,
            passwordTouched: false,
            isLoginButtonEnabled: false,
            showVerificationPrompt: false
        )
    }

    var isLoading: Bool {
        loadingState.isLoading
    }

    var errorMessage: String? {
        if case .error(let error) = loadingState {
            return error.localizedDescription
        }
        return nil
    }
}
