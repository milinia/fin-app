//
//  AnalysisViewModel.swift
//  fin-app
//
//  Created by Evelina on 10.07.2025.
//

import Foundation

final class AnalysisViewModel: LoadableObject {
    typealias DataType = [GroupedTransactions]
    
    @Published var state: LoadingState<[GroupedTransactions]> = .loading
    @Published var totalAmount: Decimal = 0
    
    private var transactionService: TransactionsServiceProtocol
    
    init(transactionService: TransactionsServiceProtocol) {
        self.transactionService = transactionService
    }
    

    func fetchTransactions(direction: Direction, startOfThePeriod: Date, endOfThePeriod: Date) async {
        do {
            let transactions = try await transactionService.fetchTransactions(
                from: startOfThePeriod,
                to: endOfThePeriod,
                by: direction
            )
            totalAmount = transactions.reduce(0) { $0 + $1.amount }
            await groupTransactions(transactions: transactions)
        } catch {
            state = .failed(error)
        }
    }

    
    @MainActor
    private func groupTransactions(transactions: [Transaction]) {
        var dict: [Category: Decimal] = [:]
        
        
        for transaction in transactions {
            dict[transaction.category, default: 0] += transaction.amount
        }
        
        let groups = dict.map { (key, value) in
                GroupedTransactions(
                    amount: value,
                    category: key,
                    percentage: calculatePercentage(amount: value)
                )
            }
            
        state = .completed(groups)
    }
    
    private func calculatePercentage(amount: Decimal) -> Int {
        guard totalAmount != 0 else { return 0 }
        let value = amount / totalAmount
        let result = value * 100
        let rounded = NSDecimalNumber(decimal: result).rounding(accordingToBehavior: nil)
        return rounded.intValue
    }
}
