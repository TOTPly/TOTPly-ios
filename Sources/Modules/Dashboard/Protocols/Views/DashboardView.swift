//
//  DashboardView.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol DashboardView: AnyObject {
    func render(_ state: DashboardViewState)
}
