//
//  LocalAuthRepository.swift
//  TOTPly-ios
//
//  Created by Matthew on 02.03.2026.
//

import Foundation

final class LocalAuthRepository: AuthRepository {
    static let validEmail = "user@test.com"
    static let validPassword = "12345"

    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    func login(email: String, password: String) async throws -> AuthResult {
        if email == Self.validEmail && password == Self.validPassword {
            let session = UserSession(
                accessToken: "local_access_token",
                refreshToken: "local_refresh_token",
                userId: "local_user",
                expiresAt: Date().addingTimeInterval(3600)
            )
            try saveSession(session)
            return .session(session)
        }
        throw AuthError.invalidCredentials
    }

    func register(email: String, password: String, displayName: String?) async throws -> AuthResult {
        if !email.isEmpty && !(password.isEmpty) {
            let session = UserSession(
                accessToken: "local_token",
                refreshToken: "local_refresh",
                userId: "local_user",
                expiresAt: Date().addingTimeInterval(3600)
            )
            try saveSession(session)
            return .session(session)
        }
        throw AppError.validationError("Email and password required")
    }

    func verifyEmail(code: String) async throws -> VerifyEmailResponse {
        VerifyEmailResponse(
            accessToken: "local_token",
            refreshToken: "local_refresh",
            userId: "local_user",
            expiresIn: 3600
        )
    }

    func resendVerificationCode(email: String) async throws -> ResendVerificationResponse {
        ResendVerificationResponse(success: true, cooldownSeconds: 60, message: "Test")
    }

    func requestPasswordReset(email: String) async throws {
        // TODO
    }

    func verifyPasswordReset(email: String, code: String, newPassword: String) async throws {
        // TODO
    }

    func getCurrentSession() -> UserSession? {
        try? storage.load(key: StorageKey.userSession.rawValue)
    }

    func saveSession(_ session: UserSession) throws {
        try storage.save(session, key: StorageKey.userSession.rawValue)
    }

    func clearSession() throws {
        try storage.delete(key: StorageKey.userSession.rawValue)
    }
}
