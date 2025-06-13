//
//  Direction.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

enum Direction: Codable, Equatable {
    case income
    case outcome
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Bool.self)
        self = value ? .income : .outcome
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .income)
    }
}
