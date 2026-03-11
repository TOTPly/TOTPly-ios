//
//  DashboardRouterStub.swift
//  TOTPly-ios
//
//  Created by Matthew on 11.03.2026.
//

import Foundation

final class DashboardRouterStub: DashboardRouter {
    func openCodeDetail(itemId: String) {
        print("[Router Stub] openCodeDetail: \(itemId)")
    }
    
    func openAddTOTP() {
        print("[Router Stub] openAddTOTP")
    }
    
    func openEditTOTP(itemId: String) {
        print("[Router Stub] openEditTOTP: \(itemId)")
    }
    
    func openSettings() {
        print("[Router Stub] openSettings")
    }
    
    func openProfile() {
        print("[Router Stub] openProfile")
    }
}
