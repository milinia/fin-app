//
//  TransactionsListModel.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import Foundation

final class TransactionsListModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    @Published var totalAmount: Decimal = 0
    
    private let transactionsService: TransactionsServiceProtocol
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
    }
    
    func fetchTransactions(direction: Direction) {
        Task {
            do {
                let startOfTheDay = Calendar.current.startOfDay(for: Date())
                let endOfTheDay = Date.startOfTomorrow
                let transactions = try await transactionsService.fetchTransactions(from: startOfTheDay, to: endOfTheDay)
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
}
