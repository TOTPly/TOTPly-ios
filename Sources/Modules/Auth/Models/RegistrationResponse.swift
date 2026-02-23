//
//  RegistrationResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct RegistrationResponse: Equatable, Codable {
    let userId: String
    let email: String
    let requiresEmailVerification: Bool
    let message: String?
}

