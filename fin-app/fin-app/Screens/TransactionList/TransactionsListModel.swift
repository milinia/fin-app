//
//  TransactionsListModel.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import Foundation

struct TransactionData: Equatable {
    let transactions: [Transaction]
    let total: Decimal
}

final class TransactionsListModel: LoadableObject {
    typealias DataType = TransactionData
    
    @Published var state: LoadingState<TransactionData>
    
    let transactionsService: TransactionsServiceProtocol
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
        self.state = .loading
    }
    
    func fetchTransactions(direction: Direction) async {
        await setLoading()
        do {
            let startOfTheDay = Calendar.current.startOfDay(for: Date())
            let endOfTheDay = Date.startOfTomorrow
            let transactions = try await transactionsService.fetchTransactions(
                from: startOfTheDay,
                to: endOfTheDay,
                by: direction
            )
            let neededTransactions = transactions.filter { $0.category.isIncome == direction }
            let totalAmount = neededTransactions.reduce(0) { $0 + $1.amount }
            await setData(transactions: neededTransactions, totalAmount: totalAmount)
        } catch {
            await setError(error)
        }
    }
    
    @MainActor
    private func setLoading() {
        state = .loading
    }
    
    @MainActor
    private func setData(transactions: [Transaction], totalAmount: Decimal) {
        state = .completed( TransactionData(transactions: transactions, total: totalAmount) )
    }
    
    @MainActor
    private func setError(_ error: Error) {
        state = .failed(error)
    }
}
