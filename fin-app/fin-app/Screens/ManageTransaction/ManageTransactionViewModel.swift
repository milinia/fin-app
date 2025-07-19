//
//  ManageTransactionViewModel.swift
//  fin-app
//
//  Created by Evelina on 11.07.2025.
//

import Foundation

final class ManageTransactionViewModel: LoadableObject {
    typealias DataType = [Category]
    
    @Published var state: LoadingState<[Category]>  = .completed([])
    
    private var categoriesService: CategoriesServiceProtocol
    var transactionsService: TransactionsServiceProtocol
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    
    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()
    
    init(categoriesService: CategoriesServiceProtocol, transactionsService: TransactionsServiceProtocol) {
        self.categoriesService = categoriesService
        self.transactionsService = transactionsService
    }
    
    
    func fetchCategories(by direction: Direction) async {
        if case .loading = state { return }
        await setLoading()
        do {
            let categories = try await categoriesService.fetchCategories(by: direction)
            await setCategories(categories: categories)
        } catch {
            await setError(error: error)
        }
    }
    
    @MainActor
    private func setLoading() {
        self.state = .loading
    }
    
    @MainActor
    private func setCategories(categories: [Category]) {
        self.state = .completed(categories)
    }
    
    @MainActor
    private func setError(error: Error) {
        self.state = .failed(error)
    }
    
    func addTransaction(
        category: Category?,
        amount: Decimal,
        transactionDate: Date,
        comment: String
    ) {
        guard let category else { return }
        Task {
            try await transactionsService.createTransaction(transactionInfo: TransactionInfo(
                id: nil,
                accountId: nil,
                currency: nil,
                categoryId: category.id,
                categoryName: category.name,
                categoryEmoji: String(category.emoji),
                isIncome: category.isIncome == .income ? true : false,
                amount: String(describing: amount),
                transactionDate: transactionDate,
                comment: comment)
            )
        }
    }
    
    func editTransaction(
        transaction: Transaction,
        newCategory: Category?,
        newAmount: Decimal,
        transactionDate: Date,
        comment: String
    ) {
        guard let newCategory else { return }
        Task {
            try await transactionsService.updateTransaction(transactionInfo: TransactionInfo(
                id: transaction.id,
                accountId: transaction.account.id,
                currency: transaction.account.currency,
                categoryId: newCategory.id,
                categoryName: newCategory.name,
                categoryEmoji: String(newCategory.emoji),
                isIncome: newCategory.isIncome == .income ? true : false,
                amount: String(describing: newAmount),
                transactionDate: transactionDate,
                comment: comment)
            )
        }
    }
    
    func deleteTransaction(transaction: Transaction?) {
        guard let transaction else { return }
        Task {
            try await transactionsService.deleteTransaction(transactionInfo: TransactionInfo(
                id: transaction.id,
                accountId: transaction.account.id,
                currency: transaction.account.currency,
                categoryId: transaction.category.id,
                categoryName: transaction.category.name,
                categoryEmoji: String(transaction.category.emoji),
                isIncome: transaction.category.isIncome == .income ? true : false,
                amount: String(describing: transaction.amount),
                transactionDate: transaction.transactionDate,
                comment: transaction.comment)
            )
        }
    }
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formatTime(date: Date) -> String {
        return timeFormatter.string(from: date)
    }
}
