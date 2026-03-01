//
//  AddTOTPViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

struct AddTOTPViewState: Equatable {
    var name: String
    var issuer: String
    var secret: String
    var loadingState: LoadingState
    var errorMessage: String?

    static var initial: AddTOTPViewState {
        AddTOTPViewState(
            name: "",
            issuer: "",
            secret: "",
            loadingState: .initial,
            errorMessage: nil
        )
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !secret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isSaving: Bool {
        loadingState == .loading
    }
}
