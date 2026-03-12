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

    var isExpiringSoon: Bool {
        timeRemaining <= 5
    }
    
    static func from(
        item: TOTPItem,
        generator: TOTPGenerator
    ) -> DashboardTOTPItem? {
        guard let code = generator.generateCode(
            secret: item.secret,
            algorithm: item.algorithm,
            digits: item.digits,
            period: item.period
        ) else {
            return nil
        }
        
        let timeRemaining = generator.getSecondsRemaining(period: item.period)
        let progress = Double(timeRemaining) / Double(item.period)
        
        return DashboardTOTPItem(
            id: item.id,
            displayName: item.name,
            issuer: item.issuer.isEmpty ? nil : item.issuer,
            currentCode: code,
            timeRemaining: timeRemaining,
            period: item.period,
            progressPercentage: progress
        )
    }
}
