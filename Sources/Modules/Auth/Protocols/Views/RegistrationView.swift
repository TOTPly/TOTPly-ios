//
//  RegistrationView.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol RegistrationView: AnyObject {
    func render(_ state: RegistrationViewState)
}
