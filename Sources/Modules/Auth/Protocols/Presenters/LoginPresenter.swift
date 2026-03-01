//
//  LoginPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol LoginPresenter {
    func viewDidLoad()
    func didTapLogin(email: String, password: String)
    func didTapForgotPassword()
    func didTapResendVerification(email: String)
    func didTapGoToRegister()
}
