//
//  VerifyEmailResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct VerifyEmailResponse: Equatable, Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
    let expiresIn: Int
}
