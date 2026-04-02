//
//  ViewState.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation

enum ViewState<Content: Equatable>: Equatable {
    case loading
    case empty
    case error(Error)
    case content(Content)

    var isContent: Bool {
        if case .content = self {
            return true
        } else {
            return false
        }
    }

    var contentValue: Content? {
        switch self {
        case .empty, .error, .loading: return nil
        case let .content(content): return content
        }
    }

    static func == (lhs: ViewState<Content>, rhs: ViewState<Content>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): true
        case (.empty, .empty): true
        case (.error, .error): true
        case let (.content(lhsContent), .content(rhsContent)): lhsContent == rhsContent
        default: false
        }
    }
}
