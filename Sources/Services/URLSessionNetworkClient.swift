//
//  URLSessionNetworkClient.swift
//  TOTPly-ios
//
//  Created by Matthew on 10.03.2026.
//

import Foundation

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared, // синглтон
        decoder: JSONDecoder? = nil
    ) {
        self.session = session
        self.decoder = decoder ?? Self.defaultDecoder()
    }
    
    func get<T: Decodable>(_ url: URL) async throws -> T {
        try await get(url, headers: [:])
    }
    
    func get<T: Decodable>(_ url: URL, headers: [String: String]) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Стандарт
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            // отсюда летит URLError - до получения HTTP ответа: соединение, таймауты, DNS, SSL/TLS
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                if let json = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(json)")
                }
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            throw mapURLError(urlError)
        } catch {
            throw NetworkError.invalidResponse
        }
    }
        
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return .noConnection
        case .timedOut:
            return .timeout
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return .dnsFailure
        case .secureConnectionFailed,
             .serverCertificateHasBadDate,
             .serverCertificateUntrusted,
             .serverCertificateHasUnknownRoot,
             .serverCertificateNotYetValid,
             .clientCertificateRejected,
             .clientCertificateRequired:
            return .sslError
        case .badServerResponse, .cannotParseResponse, .zeroByteResource:
            return .invalidResponse
        case .cancelled:
            return .cancelled
        default:
            return .invalidResponse
        }
    }
    
    private static func defaultDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}
