//
//  TOTPItem.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

// Доменная модель

struct TOTPItem: Equatable, Codable, Identifiable {
    let id: String
    let name: String
    let issuer: String?
    let secret: String
    let algorithm: TOTPAlgorithm
    let digits: Int
    let period: Int
    let createdAt: Date
    let updatedAt: Date
    let isDeleted: Bool
    let syncedAt: Date?
    
    static var `default`: TOTPItem {
        TOTPItem(
            id: UUID().uuidString,
            name: "",
            issuer: nil,
            secret: "",
            algorithm: .sha1,
            digits: 6,
            period: 30,
            createdAt: Date(),
            updatedAt: Date(),
            isDeleted: false,
            syncedAt: nil
        )
    }
}
