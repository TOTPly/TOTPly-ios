//
//  TOTPItemDTO.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

// Контракт с API

struct TOTPItemDTO: Codable, Equatable {
    let id: String
    let name: String
    let issuer: String?
    let secret: String
    let algorithm: String
    let digits: Int
    let period: Int
    let createdAt: String
    let updatedAt: String
    let isDeleted: Bool
    
    func toDomain() -> TOTPItem? {
        guard let algorithm = TOTPAlgorithm(rawValue: algorithm.uppercased()),
              let createdDate = ISO8601DateFormatter().date(from: createdAt),
              let updatedDate = ISO8601DateFormatter().date(from: updatedAt) else {
            return nil
        }
        
        return TOTPItem(
            id: id,
            name: name,
            issuer: issuer,
            secret: secret,
            algorithm: algorithm,
            digits: digits,
            period: period,
            createdAt: createdDate,
            updatedAt: updatedDate,
            isDeleted: isDeleted,
            syncedAt: Date()
        )
    }
}
