//
//  LoginResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct LoginResponse: Equatable, Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
    let expiresIn: Int
    let requiresEmailVerification: Bool
    let email: String?
}
