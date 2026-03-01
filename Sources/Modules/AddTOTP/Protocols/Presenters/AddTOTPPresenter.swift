//
//  AddTOTPPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol AddTOTPPresenter {
    func viewDidLoad()
    func didTapCancel()
    func didTapScanQR()
    func didSave(name: String, issuer: String, secret: String)
}
