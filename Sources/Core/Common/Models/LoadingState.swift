//
//  LoadingState.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

enum LoadingState: Equatable {
    case initial
    case loading
    case loaded
    case error(AppError)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
