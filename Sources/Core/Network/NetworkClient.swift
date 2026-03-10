//
//  NetworkClient.swift
//  TOTPly-ios
//
//  Created by Matthew on 10.03.2026.
//

import Foundation

protocol NetworkClient {
    // Выполняет GET запрос и декодирует ответ
    // - Вход: url для запроса
    // - Выход: декодированный объект типа T
    // - throws: NetworkError при ошибках сети, статуса или декодирования
    func get<T: Decodable>(_ url: URL) async throws -> T
    
    // Выполняет GET запрос с заголовками и декодирует ответ
    // - Вход: url для запроса, http заголовки
    // - Выход: декодированный объект типа T
    // - throws: NetworkError при ошибках сети, статуса или декодирования
    func get<T: Decodable>(_ url: URL, headers: [String: String]) async throws -> T
}
