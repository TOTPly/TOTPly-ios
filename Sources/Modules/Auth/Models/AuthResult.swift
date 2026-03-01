//
//  AuthResult.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

// Подтверждение почты нужно всегда при логине или регистрации поэтому сессия с токеном создается не сразу
enum AuthResult: Equatable {
    case session(UserSession)
    case requiresEmailVerification(email: String)
}
