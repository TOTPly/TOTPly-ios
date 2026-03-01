//
//  CodeDetailRouter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol CodeDetailRouter {
    func showDeleteConfirmation(onConfirm: @escaping () -> Void)
    func popToDashboard()
}
