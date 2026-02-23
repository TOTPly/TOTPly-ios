//
//  LoginRequest.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct LoginRequest: Equatable, Codable {
    let email: String
    let password: String
    let deviceInfo: DeviceInfo?
}
