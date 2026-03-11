//
//  NetworkError.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

enum NetworkError: Error, Equatable {
    case noConnection
    case timeout
    case serverError(Int)
    case invalidResponse
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "Нет подключения к интернету"
        case .timeout:
            return "Время на запрос вышло"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .decodingError:
            return "Неверно расшифрован ответ сервера"
        }
    }
}
