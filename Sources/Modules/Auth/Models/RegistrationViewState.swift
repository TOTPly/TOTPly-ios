//
//  RegistrationViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct RegistrationViewState: Equatable {
    var loadingState: LoadingState
    var email: String
    var password: String
    var confirmPassword: String
    var displayName: String
    var validationErrors: ValidationErrors
    var emailTouched: Bool
    var passwordTouched: Bool
    var confirmPasswordTouched: Bool
    var displayNameTouched: Bool
    var isRegisterButtonEnabled: Bool

    struct ValidationErrors: Equatable {
        var emailError: String?
        var passwordError: String?
        var confirmPasswordError: String?
        var displayNameError: String?
    }

    static var initial: RegistrationViewState {
        RegistrationViewState(
            loadingState: .initial,
            email: "",
            password: "",
            confirmPassword: "",
            displayName: "",
            validationErrors: ValidationErrors(),
            emailTouched: false,
            passwordTouched: false,
            confirmPasswordTouched: false,
            displayNameTouched: false,
            isRegisterButtonEnabled: false
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
