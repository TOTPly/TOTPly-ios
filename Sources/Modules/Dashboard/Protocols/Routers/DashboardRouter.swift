//
//  DashboardRouter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol DashboardRouter {
    func openCodeDetail(item: TOTPItem)
    func openAddTOTP()
    func openEditTOTP(item: TOTPItem)
    func openSettings()
    func openProfile()
}
