//
//  NetworkError.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

enum NetworkError: Error, Equatable {
    case noConnection
    case timeout
    case unauthorized
    case serverError(Int)
    case invalidResponse
    case decodingError
    case dnsFailure
    case sslError
    case cancelled
    
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "Нет подключения к интернету"
        case .timeout:
            return "Время на запрос вышло"
        case .unauthorized:
            return "Необходима авторизация"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .decodingError:
            return "Неверно расшифрован ответ сервера"
        case .dnsFailure:
            return "Не удалось найти сервер"
        case .sslError:
            return "Ошибка безопасного соединения"
        case .cancelled:
            return "Запрос отменён"
        }
    }
}
