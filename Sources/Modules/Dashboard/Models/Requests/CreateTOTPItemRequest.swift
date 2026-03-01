//
//  CreateTOTPItemRequest.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct CreateTOTPItemRequest: Codable, Equatable {
    let name: String
    let issuer: String
    let secret: String
    let algorithm: String
    let digits: Int
    let period: Int
}
