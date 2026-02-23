//
//  AppError.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

enum AppError: Error, Equatable {
    case networkError(NetworkError)
    case authError(AuthError)
    case validationError(String)
    case storageError(String)
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .authError(let error):
            return error.localizedDescription
        case .validationError(let message):
            return message
        case .storageError(let message):
            return "Storage error: \(message)"
        case .unknown(let message):
            return message
        }
    }
}
