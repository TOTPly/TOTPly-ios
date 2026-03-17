//
//  TOTPCellModel.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import Foundation

struct TOTPCellModel: Hashable {
    let id: String
    let title: String
    let subtitle: String?
    let code: String
    let timeRemaining: String
    let progress: Double
    let isExpiringSoon: Bool

    static func from(item: DashboardTOTPItem, masked: Bool) -> TOTPCellModel {
        TOTPCellModel(
            id: item.id,
            title: item.displayName,
            subtitle: item.issuer,
            code: masked ? "••• •••" : item.formattedCode,
            timeRemaining: "\(item.timeRemaining)s",
            progress: item.progressPercentage,
            isExpiringSoon: item.isExpiringSoon
        )
    }
}
