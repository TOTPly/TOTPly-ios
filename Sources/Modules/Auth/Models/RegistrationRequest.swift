//
//  RegistrationRequest.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct RegistrationRequest: Equatable, Codable {
    let email: String
    let password: String
    let displayName: String?
    let deviceInfo: DeviceInfo?
}
