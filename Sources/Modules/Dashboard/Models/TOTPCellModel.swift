//
//  TOTPCellModel.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import Foundation

// де-факто view state ячейки таблицы в то время как DashboardTOTPItem "абстрактная" модель отображения TOTPItem
// тем не менее, логика чистая: TOTPItem просто знает про алгоритм и секрет
// потом происходит from(TOTPItem) у DashboardTOTPItem и рождается код, оставшееся время
// (то есть именно то что хотим показывать)
// Ну а TOTPCellModel может что то добавить (title, subtitle и тд) или выкинуть для обертки в ячейку таблицы

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
