//
//  DashboardTOTPItem.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

// Модель отображения

struct DashboardTOTPItem: Equatable, Identifiable {
    let id: String
    let displayName: String
    let issuer: String?
    let currentCode: String
    let timeRemaining: Int
    let period: Int
    let progressPercentage: Double

    var formattedCode: String {
        let middle = currentCode.count / 2
        let firstPart = currentCode.prefix(middle)
        let secondPart = currentCode.suffix(currentCode.count - middle)
        return "\(firstPart) \(secondPart)"
    }

    var displayIssuer: String {
        issuer ?? "Unknown"
    }

    var isExpiringSoon: Bool {
        timeRemaining <= 5
    }
}
