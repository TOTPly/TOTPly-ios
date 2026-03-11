//
//  RemoteTOTPRepository.swift
//  TOTPly-ios
//
//  Created by Matthew on 10.03.2026.
//

import Foundation

final class RemoteTOTPRepository: TOTPRepository {
    private let networkClient: NetworkClient
    private let storage: StorageService
    private let baseURL: String
    private let echoPath: String
    
    init(
        networkClient: NetworkClient,
        storage: StorageService,
        baseURL: String = "https://alfaitmo.ru/server/echo",
        echoPath: String = "471057/totply-ios/items"
    ) {
        self.networkClient = networkClient
        self.storage = storage
        self.baseURL = baseURL
        self.echoPath = echoPath
    }
    
    private func saveItemsToLocalStorage(_ items: [TOTPItem]) throws {
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    
    func fetchRemoteItems() async throws -> [TOTPItem] {
        guard let url = URL(string: "\(baseURL)/\(echoPath)") else {
            throw NetworkError.invalidResponse
        }
        
        let response: TOTPItemsResponse = try await networkClient.get(url)
        
        // Пока что если хотя бы один элемент невалиден то кидаем ошибку
        let items = try response.items.map { try $0.toDomain() }
        
        try saveItemsToLocalStorage(items)
        
        return items
    }
    
    func fetchLocalItems() async throws -> [TOTPItem] {
        // грузим из локального кейчейна
        guard let items: [TOTPItem] = try storage.load(key: StorageKey.totpItems.rawValue) else {
            return []
        }
        return items.filter { !$0.isDeleted }
    }
    
    func saveItem(_ item: TOTPItem) async throws {
        // Пока сохраняем только локально
        var items = try await fetchLocalItems()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    func deleteItem(id: String) async throws {
        // Пока помечаем как удалённый локально
        var items = try await fetchLocalItems()
        if let index = items.firstIndex(where: { $0.id == id }) {
            var item = items[index]
            items[index] = TOTPItem(
                id: item.id,
                name: item.name,
                issuer: item.issuer,
                secret: item.secret,
                algorithm: item.algorithm,
                digits: item.digits,
                period: item.period,
                createdAt: item.createdAt,
                updatedAt: Date(),
                isDeleted: true,
                syncedAt: item.syncedAt
            )
        }
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
}
