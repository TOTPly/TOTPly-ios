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
            return "Нверная почта или пароль"
        case .emailNotVerified:
            return "Почта не подтверждена"
        case .sessionExpired:
            return "Сессия просрочена"
        case .refreshTokenExpired:
            return "Войдите снова"
        case .unauthorized:
            return "Не авторизован"
        case .accountLocked:
            return "Аккаунт заморожен"
        case .tooManySessions:
            return "Слишком много сессий"
        case .suspiciousActivity:
            return "Подозрительная активность"
        }
    }
}
