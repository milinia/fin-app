//
//  ManageTransactionViewModel.swift
//  fin-app
//
//  Created by Evelina on 11.07.2025.
//

import Foundation

final class ManageTransactionViewModel: ObservableObject {
    
    @Published var categories: [Category] = []
    
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
        do {
            let categories = try await categoriesService.fetchCategories(by: direction)
            await setData(categories: categories)
        } catch {
            
        }
    }
    
    @MainActor
    private func setData(categories: [Category]) {
        self.categories = categories
    }
    
    func addTransaction(account: BankAccount, category: Category?, amount: Decimal, comment: String) {
        guard let category else { return }
        Task {
            try await transactionsService.createTransaction(account: account,
                                                  category: category,
                                                  amount: amount,
                                                  comment: comment)
        }
    }
    
    func editTransaction(transaction: Transaction, newCategory: Category?, newAmount: Decimal, comment: String) {
        guard let newCategory else { return }
        Task {
            try await transactionsService.updateTransaction(transaction: transaction,
                                                            newCategory: newCategory,
                                                            newAmount: newAmount,
                                                            comment: comment)
        }
    }
    
    func deleteTransaction(transaction: Transaction?) {
        guard let transaction else { return }
        Task {
            try await transactionsService.deleteTransaction(transactionId: transaction.id)
        }
    }
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formatTime(date: Date) -> String {
        return timeFormatter.string(from: date)
    }
}
