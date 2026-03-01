//
//  TOTPAlgorithm.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

enum TOTPAlgorithm: String, Codable, Equatable {
    case sha1 = "SHA1"
    case sha256 = "SHA256"
    case sha512 = "SHA512"
}
