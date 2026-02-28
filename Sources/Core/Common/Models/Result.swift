//
//  Result.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(AppError)
}
