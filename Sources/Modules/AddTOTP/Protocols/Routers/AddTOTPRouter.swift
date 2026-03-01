//
//  AddTOTPRouter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol AddTOTPRouter {
    func popToDashboard()
    func openQRScanner(completion: @escaping (String) -> Void)
}
