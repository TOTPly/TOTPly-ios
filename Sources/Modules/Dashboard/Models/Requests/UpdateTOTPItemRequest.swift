//
//  UpdateTOTPItemRequest.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

struct UpdateTOTPItemRequest: Codable, Equatable {
    let name: String
    let issuer: String
}
