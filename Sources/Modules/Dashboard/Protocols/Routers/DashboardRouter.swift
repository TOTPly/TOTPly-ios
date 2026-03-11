//
//  DashboardRouter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol DashboardRouter {
    func openCodeDetail(itemId: String)
    func openAddTOTP()
    func openSettings()
    func openProfile()
}
