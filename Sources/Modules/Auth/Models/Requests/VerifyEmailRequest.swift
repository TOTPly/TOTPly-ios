//
//  VerifyEmailRequest.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct VerifyEmailRequest: Equatable, Codable {
    let code: String
}
