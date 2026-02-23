//
//  VerificationResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

struct VerificationResponse: Equatable, Codable {
    let success: Bool
    let message: String?
    let remainingAttempts: Int?
}
