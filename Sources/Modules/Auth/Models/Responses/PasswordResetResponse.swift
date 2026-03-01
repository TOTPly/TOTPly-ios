//
//  PasswordResetResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct PasswordResetResponse: Equatable, Codable {
    let success: Bool
    let message: String?
}
