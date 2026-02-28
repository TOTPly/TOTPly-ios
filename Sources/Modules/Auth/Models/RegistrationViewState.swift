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
    var displayName: String
    var validationErrors: ValidationErrors
    var isRegisterButtonEnabled: Bool

    struct ValidationErrors: Equatable {
        var emailError: String?
        var passwordError: String?
        var displayNameError: String?
    }

    static var initial: RegistrationViewState {
        RegistrationViewState(
            loadingState: .initial,
            email: "",
            password: "",
            displayName: "",
            validationErrors: ValidationErrors(),
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
