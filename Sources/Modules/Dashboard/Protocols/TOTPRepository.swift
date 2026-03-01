//
//  TOTPRepository.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol TOTPRepository {
    func fetchLocalItems() async throws -> [TOTPItem]
    func fetchRemoteItems() async throws -> [TOTPItem]
    func saveItem(_ item: TOTPItem) async throws
    func deleteItem(id: String) async throws
}
