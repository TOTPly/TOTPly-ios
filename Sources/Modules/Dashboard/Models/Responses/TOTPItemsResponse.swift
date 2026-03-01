//
//  TOTPItemsResponse.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct TOTPItemsResponse: Codable {
    let items: [TOTPItemDTO]
    let syncTimestamp: Date
}
