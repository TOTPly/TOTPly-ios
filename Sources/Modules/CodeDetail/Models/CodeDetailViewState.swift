//
//  CodeDetailViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

struct CodeDetailViewState: Equatable {
    var loadingState: LoadingState
    var item: TOTPItem?
    var currentCode: String
    var timeRemaining: Int
    var progressPercentage: Double
    var isEditing: Bool  // для редактировния нужно нажать соответствующую кнопку

    static var initial: CodeDetailViewState {
        CodeDetailViewState(
            loadingState: .initial,
            item: nil,
            currentCode: "------",
            timeRemaining: 0,
            progressPercentage: 0.0,
            isEditing: false
        )
    }
    
    var formattedCode: String {
        let middle = currentCode.count / 2
        let firstPart = currentCode.prefix(middle)
        let secondPart = currentCode.suffix(currentCode.count - middle)
        return "\(firstPart) \(secondPart)"
    }
    
    var displayName: String {
        guard let item = item else { return "Unknown" }
        if !item.issuer.isEmpty {
            return "\(item.issuer) - \(item.name)"
        }
        return item.name
    }
    
    var isExpiringSoon: Bool {
        timeRemaining <= 5
    }

    var canDelete: Bool {
        loadingState != .loading
    }
}
