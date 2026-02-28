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
            return "No internet connection"
        case .timeout:
            return "Request timeout"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
