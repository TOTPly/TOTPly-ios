//
//  LoginResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct LoginResponse: Equatable, Codable {
    let userId: String
    let email: String
    let message: String?
}
