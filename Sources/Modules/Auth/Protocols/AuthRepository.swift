//
//  AuthRepository.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> AuthResult
    func register(email: String, password: String, displayName: String?) async throws -> AuthResult
    func verifyEmail(code: String) async throws -> VerificationResponse
    func resendVerificationCode(email: String) async throws -> ResendVerificationResponse
    func requestPasswordReset(email: String) async throws
    func verifyPasswordReset(email: String, code: String, newPassword: String) async throws
    func getCurrentSession() -> UserSession?
    func saveSession(_ session: UserSession) throws
    func clearSession() throws
}
