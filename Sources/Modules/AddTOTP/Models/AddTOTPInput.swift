//
//  AddTOTPInput.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

struct AddTOTPInput: Equatable {
    let prefilledSecret: String?  // может прилететь из QR
    let prefilledName: String?    // может прилететь из QR
    let prefilledIssuer: String?  // может прилететь из QR

    static var empty: AddTOTPInput {
        AddTOTPInput(prefilledSecret: nil, prefilledName: nil, prefilledIssuer: nil)
    }
}
