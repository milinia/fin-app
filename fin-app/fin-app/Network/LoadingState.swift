//
//  LoadingState.swift
//  fin-app
//
//  Created by Evelina on 16.07.2025.
//

import Foundation

enum LoadingState<T: Equatable>: Equatable {
    case loading
    case completed(T)
    case failed(Error)
    
    var value: T? {
        switch self {
        case .completed(let value):
            return value
        default:
            return nil
        }
    }
    
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.completed(a), .completed(b)):
            return a == b
        case (.failed, .failed):
            return false
        default:
            return false
        }
    }
}
