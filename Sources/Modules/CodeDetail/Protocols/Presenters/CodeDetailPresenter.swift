//
//  CodeDetailPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol CodeDetailPresenter {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didTapCopyCode()
    func didTapEdit()
    func didTapCancelEdit()
    func didSave(name: String, issuer: String)
    func didTapDelete()
    func didConfirmDelete()
    func didTapShare()
    func timerDidTick()
}
