//
//  HistoryModel.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import Foundation
import SwiftUI

final class HistoryModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    @Published var totalAmount: Decimal = 0
    @Published var startOfThePeriod: Date = .now
    @Published var endOfThePeriod: Date = .now
    
    private let transactionsService: TransactionsServiceProtocol = TransactionsService()
    private var direction: Direction = .income
    
    init() {
        let dayMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? .now
        startOfThePeriod = Calendar.current.startOfDay(for: dayMonthAgo)
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
        let tomorrowStartOfDay = Calendar.current.startOfDay(for: tomorrow)
        endOfThePeriod = Calendar.current.date(byAdding: .minute, value: -1, to: tomorrowStartOfDay) ?? .now
    }
    
    func fetchTransactions(direction: Direction) {
        Task {
            do {
                self.direction = direction
                let transactions = try await transactionsService.fetchTransactions(from: startOfThePeriod, to: endOfThePeriod)
                let neededTransactions = transactions.filter { $0.category.isIncome == direction }
                let totalAmount = neededTransactions.reduce(0) { $0 + $1.amount }
                await setData(transactions: neededTransactions, totalAmount: totalAmount)
            } catch {
                
            }
        }
    }
    
    @MainActor
    private func setData(transactions: [Transaction], totalAmount: Decimal) {
        self.transactions = transactions
        self.totalAmount = totalAmount
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func setStartOfThePeriod(_ date: Date) {
        startOfThePeriod = Calendar.current.startOfDay(for: date)
        
        if startOfThePeriod > endOfThePeriod {
            setEndOfThePeriod(startOfThePeriod)
        }
        
        fetchTransactions(direction: direction)
    }
    
    func setEndOfThePeriod(_ date: Date) {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? .now
        let tomorrowStartOfDay = Calendar.current.startOfDay(for: tomorrow)
        endOfThePeriod = Calendar.current.date(byAdding: .minute, value: -1, to: tomorrowStartOfDay) ?? .now
        
        if startOfThePeriod > endOfThePeriod {
            setStartOfThePeriod(endOfThePeriod)
        }
        
        fetchTransactions(direction: direction)
    }
    
    func sortOperation(by value: SortOperations) {
        if value == .byDate {
            transactions.sort(by: { $0.transactionDate > $1.transactionDate })
        } else {
            transactions.sort(by: { $0.amount > $1.amount })
        }
    }
}
