//
//  AuthRouterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 02.03.2026.
//

import UIKit

final class AuthRouterImpl: AuthRouter, WelcomeRouter {
    private weak var window: UIWindow?
    private let authRepository: AuthRepository  // просто отдаем внутрь презентеров
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?, authRepository: AuthRepository) {
        self.window = window
        self.authRepository = authRepository
    }
    
    func start() {
        let welcome = makeWelcomeViewController()
        let nav = UINavigationController(rootViewController: welcome)
        nav.navigationBar.prefersLargeTitles = false
        navigationController = nav
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    private func makeWelcomeViewController() -> WelcomeViewController {
        let presenter = WelcomePresenterImpl(router: self)
        let vc = WelcomeViewController(presenter: presenter)
        presenter.setView(vc)
        return vc
    }
    
    private func makeLoginViewController() -> LoginViewController {
        let presenter = LoginPresenterImpl(router: self, authRepository: authRepository)
        let vc = LoginViewController(presenter: presenter)
        presenter.setView(vc)
        return vc
    }
    
    private func makeRegistrationViewController() -> RegistrationViewController {
        let presenter = RegistrationPresenterImpl(router: self, authRepository: authRepository)
        let vc = RegistrationViewController(presenter: presenter)
        presenter.setView(vc)
        return vc
    }
    
    func openLogin() {
        navigationController?.pushViewController(makeLoginViewController(), animated: true)
    }
    
    func openRegistration() {
        guard let nav = navigationController else { return }
        if let registrationVC = nav.viewControllers.first(where: { $0 is RegistrationViewController }) {
            nav.popToViewController(registrationVC, animated: true)
        } else {
            nav.pushViewController(makeRegistrationViewController(), animated: true)
        }
    }
    
    func openPasswordRecovery() {
        // Заглушка
        let alert = UIAlertController(title: "Восстановление пароля", message: "Заглушка.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController?.topViewController?.present(alert, animated: true)
    }
    
    func openEmailVerification(email: String, type: VerificationType) {
        // Заглушка
        let alert = UIAlertController(title: "Верификация", message: "Заглущка. Почта: \(email)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController?.topViewController?.present(alert, animated: true)
    }
    
    func openDashboard() {
        let networkClient = URLSessionNetworkClient()
        let storage = KeychainStorageService()
        let repository = RemoteTOTPRepository(
            networkClient: networkClient,
            storage: storage,
            useMockData: true
        )
        let generator = TOTPGeneratorImpl()
        

        let router = DashboardRouterImpl()

        let view = DashboardViewController()
        let presenter = DashboardPresenterImpl(
            view: view,
            repository: repository,
            generator: generator,
            router: router
        )
        view.presenter = presenter
        
        let nav = UINavigationController(rootViewController: view)
        nav.navigationBar.prefersLargeTitles = true
        router.navigationController = nav
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func goBackToLogin() {
        guard let nav = navigationController else { return }
        if nav.viewControllers.contains(where: { $0 is LoginViewController }) {
            nav.popToViewController(nav.viewControllers.first(where: { $0 is LoginViewController })!, animated: true)
        } else {
            nav.pushViewController(makeLoginViewController(), animated: true)
        }
    }
}
