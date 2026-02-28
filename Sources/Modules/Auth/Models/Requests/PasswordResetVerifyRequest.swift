//
//  PasswordResetVerifyRequest.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct PasswordResetVerifyRequest: Equatable, Codable {
    let email: String
    let code: String
    let newPassword: String
}
