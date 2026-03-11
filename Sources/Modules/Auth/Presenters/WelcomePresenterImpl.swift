//
//  WelcomePresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import Foundation

final class WelcomePresenterImpl: WelcomePresenter {
    private weak var view: WelcomeView?
    private let router: WelcomeRouter

    init(router: WelcomeRouter) {
        self.router = router
    }

    func setView(_ view: WelcomeView) {
        self.view = view
    }

    func viewDidLoad() {
        view?.render(.initial)
    }

    func didTapSignIn() {
        router.openLogin()
    }

    func didTapCreateAccount() {
        router.openRegistration()
    }
}
