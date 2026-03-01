//
//  RegistrationPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol RegistrationPresenter {
    func viewDidLoad()
    func didTapRegister(email: String, password: String, displayName: String?)
    func didTapGoToLogin()
}
