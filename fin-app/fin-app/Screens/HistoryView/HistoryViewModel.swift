//
//  HistoryViewModel.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import Foundation
import SwiftUI

final class HistoryViewModel: LoadableObject {
    typealias DataType = [Transaction]
    
    
    @Published var state: LoadingState<[Transaction]> = .loading
    @Published var totalAmount: Decimal = 0
    @Published var startOfThePeriod: Date
    @Published var endOfThePeriod: Date
    
    let transactionsService: TransactionsServiceProtocol
    private var direction: Direction = .income
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
        
        startOfThePeriod = Date.dayMonthAgo
        endOfThePeriod = Date.startOfTomorrow
    }
    
    func fetchTransactions(direction: Direction) async {
        do {
            self.direction = direction
            let transactions = try await transactionsService.fetchTransactions(
                from: startOfThePeriod,
                to: endOfThePeriod,
                by: direction)
            let totalAmount = transactions.reduce(0) { $0 + $1.amount }
            await setData(transactions: transactions, totalAmount: totalAmount)
        } catch {
            state = .failed(error)
        }
    }
    
    @MainActor
    private func setData(transactions: [Transaction], totalAmount: Decimal) {
        self.state = .completed(transactions)
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
        
        Task {
            await fetchTransactions(direction: direction)
        }
    }
    
    func setEndOfThePeriod(_ date: Date) {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? .now
        let tomorrowStartOfDay = Calendar.current.startOfDay(for: tomorrow)
        endOfThePeriod = Calendar.current.date(byAdding: .minute, value: -1, to: tomorrowStartOfDay) ?? .now
        
        if startOfThePeriod > endOfThePeriod {
            setStartOfThePeriod(endOfThePeriod)
        }
        
        Task {
            await fetchTransactions(direction: direction)
        }
    }
    
    func sortOperation(by value: SortBy) {
        Task {
            guard var transactions = self.state.value else { return }
            if value == .byDate {
                transactions.sort(by: { $0.transactionDate > $1.transactionDate })
            } else {
                transactions.sort(by: { $0.amount > $1.amount })
            }
            
            await setData(transactions: transactions, totalAmount: totalAmount)
        }
    }
}
