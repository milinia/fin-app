//
//  LoadingState.swift
//  fin-app
//
//  Created by Evelina on 16.07.2025.
//

import Foundation

enum LoadingState<T> {
    case loading
    case idle
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
}
