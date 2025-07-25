//
//  MyBalanceModel.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import Foundation

final class MyBalanceModel: LoadableObject {
    typealias DataType = BankAccount
    
    @Published var state: LoadingState<BankAccount>
    @Published var selectedCurrency: CurrencySign = .rub
    @Published var balance: Decimal = 0
    @Published var balanceString: String = ""
    @Published var statistics: [TransactionStatistics] = []
    
    private let bankAccountService: BankAccountsServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    
    init(bankAccountService: BankAccountsServiceProtocol, transactionsService: TransactionsServiceProtocol) {
        self.bankAccountService = bankAccountService
        self.transactionsService = transactionsService
        state = .loading
    }
    
    func fetchBankAccount() async {
        do {
            let account = try await bankAccountService.fetchBankAccount()
            guard let account = account else {
                throw NetworkError.requestError
            }
            await setBankAccount(account)
        } catch {
            await setError(error)
        }
    }
    
    func getTransactionsStatistics(isDayStatistics: Bool) async {
        do {
            let transactions = try await transactionsService.fetchTransactions(
                from: isDayStatistics ? Date.dayMonthAgo : Date.twoYearsAgo,
                to: Date.startOfTomorrow,
                by: nil
            )
            
            let calendar = Calendar.current
            
            var dict: [Date: Double] = transactions.reduce(into: [:]) { result, transaction in
                let date = isDayStatistics ? calendar.startOfDay(for: transaction.transactionDate) : calendar.startOfMonth(for: transaction.transactionDate)
                if transaction.category.isIncome == .income {
                    result[date, default: 0] += (transaction.amount as NSDecimalNumber).doubleValue
                } else {
                    result[date, default: 0] -= (transaction.amount as NSDecimalNumber).doubleValue
                }
            }
            
            var startDate = isDayStatistics ? Date.dayMonthAgo : Date.twoYearsAgo
            let endDate = Date.startOfTomorrow
            
            while startDate < endDate {
                let date = isDayStatistics ? calendar.startOfDay(for: startDate) : calendar.startOfMonth(for: startDate)
                if dict[date] == nil {
                    dict[date] = 0
                }
                startDate = calendar.date(byAdding: isDayStatistics ? .day : .month, value: 1, to: startDate) ?? Date()
            }
            
            let statisticsArray = dict.map { TransactionStatistics(date: $0.key, balance: $0.value) }
            await setStaistics(statisticsArray)
        } catch {
            await setError(error)
        }
    }
    
    @MainActor
    private func setError(_ error: Error) {
        state = .failed(error)
    }
    
    @MainActor
    private func setStaistics(_ statistics: [TransactionStatistics]) {
        self.statistics = statistics
    }
    
    @MainActor
    private func setBankAccount(_ account: BankAccount) {
        state = .completed(account)
        
        let currency = account.currency
        let currencySign = CurrencySign(rawValue: currency) ?? .usd
        selectedCurrency = currencySign
        
        self.balance = account.balance
        let balanceString = String(describing: balance)
        let balanceFormatted = balanceString.amountFormatted()
        self.balanceString = balanceFormatted
    }
    
    func updateBankAccount() {
        Task {
            do {
                guard let newAccount = try await bankAccountService.updateBankAccount(balance: balance,
                                                                                currency: selectedCurrency.rawValue)
                else {
                    return
                }
                await setBankAccount(newAccount)
            }
        }
    }
    
    func updateBalance(_ newBalance: String) {
        balance = Decimal(string: newBalance) ?? 0
        balanceString = newBalance.amountFormatted()
    }
}
