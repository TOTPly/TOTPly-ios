//
//  ResendVerificationResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct ResendVerificationResponse: Equatable, Codable {
    let success: Bool
    let cooldownSeconds: Int
    let message: String?
}
