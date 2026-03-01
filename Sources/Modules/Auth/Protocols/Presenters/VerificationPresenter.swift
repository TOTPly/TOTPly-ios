//
//  VerificationPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol VerificationPresenter {
    func viewDidLoad()
    func didEnterCode(_ code: String)
    func didTapVerify()
    func didTapResendCode()
    func didTapBack()
}
