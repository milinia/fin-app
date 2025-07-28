//
//  Calendar+StartOfMonth.swift
//  fin-app
//
//  Created by Evelina on 24.07.2025.
//

import Foundation

extension Calendar {
    public func startOfMonth(for date: Date) -> Date {
        var components = dateComponents([.year, .month], from: date)
        components.day = 1
        return self.date(from: components) ?? date
    }
}
