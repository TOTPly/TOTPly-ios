//
//  VerificationViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct VerificationViewState: Equatable {
    var loadingState: LoadingState
    var email: String
    var code: String
    var codeLength: Int
    var remainingAttempts: Int?
    var canResendCode: Bool
    var resendCooldownSeconds: Int
    var verificationType: VerificationType
    var validationError: String?
    
    static func initial(email: String, type: VerificationType) -> VerificationViewState {
        VerificationViewState(
            loadingState: .initial,
            email: email,
            code: "",
            codeLength: 6,
            remainingAttempts: nil,
            canResendCode: false,
            resendCooldownSeconds: 60,
            verificationType: type,
            validationError: nil
        )
    }
    
    var isLoading: Bool {
        loadingState.isLoading
    }
    
    var isCodeComplete: Bool {
        code.count == codeLength
    }
    
    var errorMessage: String? {
        if case .error(let error) = loadingState {
            return error.localizedDescription
        }
        return validationError
    }
}
