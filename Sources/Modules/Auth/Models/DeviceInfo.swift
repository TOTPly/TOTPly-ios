//
//  DeviceInfo.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct DeviceInfo: Equatable, Codable {
    let deviceId: String
    let deviceName: String
    let osVersion: String
    let appVersion: String
}
