//
//  StorageService.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol StorageService {
    func save<T: Encodable>(_ value: T, key: String) throws
    func load<T: Decodable>(key: String) throws -> T?
    func delete(key: String) throws
    func exists(key: String) -> Bool
    func clearAll() throws
}
