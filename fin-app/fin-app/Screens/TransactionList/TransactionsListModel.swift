//
//  TransactionsListModel.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import Foundation

final class TransactionsListModel: LoadableObject {
    typealias DataType = ([Transaction], Decimal)
    
    @Published var state: LoadingState<([Transaction], Decimal)>
    
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
        state = .completed( (transactions, totalAmount) )
    }
    
    @MainActor
    private func setError(_ error: Error) {
        state = .failed(error)
    }
}
