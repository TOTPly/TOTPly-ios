//
//  TOTPGenerator.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol TOTPGenerator {
    func generateCode(secret: String, algorithm: TOTPAlgorithm, digits: Int, period: Int) -> String?
    func getCurrentTimeStep(period: Int) -> Int
    func getSecondsRemaining(period: Int) -> Int
}
