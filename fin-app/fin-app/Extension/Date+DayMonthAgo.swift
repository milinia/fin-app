//
//  Date+DayMonthAgo.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import Foundation

extension Date {
    static var dayMonthAgo: Date {
        let dayMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? .now
        return Calendar.current.startOfDay(for: dayMonthAgo)
    }
    
    static var startOfTomorrow: Date {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
        return Calendar.current.startOfDay(for: tomorrow)
    }
}
