//
//  Entity.swift
//  PieChart
//
//  Created by Evelina on 22.07.2025.
//

import Foundation

public struct Entity {
    let value: Decimal
    let label: String
    
    public init(value: Decimal, label: String) {
        self.value = value
        self.label = label
    }
}
