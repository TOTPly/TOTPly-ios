//
//  DashboardPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol DashboardPresenter {
    func viewDidLoad()
    func viewWillAppear()
    func didPullToRefresh()
    func didSelectItem(at index: Int)
    func didTapAddNew()
    func didTapSettings()
    func didTapCopyCode(itemId: String)
    func didSearch(query: String)
    func didTapDelete(itemId: String)
    func didTapToggleCodeMask()
}
