//
//  KeychainStorageService.swift
//  TOTPly-ios
//
//  Created by Matthew on 02.03.2026.
//

import Foundation
import Security

enum KeychainStorageError: Error {
    case unexpectedStatus(OSStatus)
}

final class KeychainStorageService: StorageService {
    private let service: String
    private let prefix: String

    init(service: String = "totply.storage", prefix: String = "totply_") {
        self.service = service
        self.prefix = prefix
    }

    private func account(for key: String) -> String {
        prefix + key
    }

    private func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account(for: key)
        ]
    }

    func save<T: Encodable>(_ value: T, key: String) throws {
        let data = try JSONEncoder().encode(value)

        var query = baseQuery(for: key)
        SecItemDelete(query as CFDictionary)

        query[kSecValueData as String] = data
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainStorageError.unexpectedStatus(status)
        }
    }

    func load<T: Decodable>(key: String) throws -> T? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess else {
            throw KeychainStorageError.unexpectedStatus(status)
        }
        guard let data = result as? Data else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func delete(key: String) throws {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainStorageError.unexpectedStatus(status)
        }
    }

    func exists(key: String) -> Bool {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = kCFBooleanFalse
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func clearAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainStorageError.unexpectedStatus(status)
        }
    }
}

