//
//  AuthError.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

enum AuthError: Error, Equatable {
    case invalidCredentials
    case emailNotVerified
    case sessionExpired
    case refreshTokenExpired
    case unauthorized
    case accountLocked
    case tooManySessions
    case suspiciousActivity
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailNotVerified:
            return "Please verify your email"
        case .sessionExpired:
            return "Your session has expired"
        case .refreshTokenExpired:
            return "Please login again"
        case .unauthorized:
            return "Unauthorized access"
        case .accountLocked:
            return "Account is locked"
        case .tooManySessions:
            return "Too many active sessions"
        case .suspiciousActivity:
            return "Suspicious activity detected"
        }
    }
}
