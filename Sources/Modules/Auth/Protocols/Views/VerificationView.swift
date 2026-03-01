//
//  VerificationView.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol VerificationView: AnyObject {
    func render(_ state: VerificationViewState)
}
