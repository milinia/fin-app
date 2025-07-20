//
//  AppDependencies.swift
//  fin-app
//
//  Created by Evelina on 19.07.2025.
//

import Foundation

import Foundation
import SwiftUI
import SwiftData

final class AppDependencies: ObservableObject {
    let networkClient: NetworkClientProtocol
    let transactionService: TransactionsServiceProtocol
    let bankAccountService: BankAccountsServiceProtocol
    let categoryService: CategoriesServiceProtocol
    let categoriesCache: CategoryCacheProtocol
    let transactionCache: TransactionCacheProtocol
    let bankAccountCache: BankAccountCacheProtocol
    let transactionBackup: TransactionBackupProtocol

    private init(
        userAccountId: Int,
        modelContainer: ModelContainer,
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient

        self.categoriesCache = CategorySwiftDataCache(modelContainer: modelContainer)
        self.transactionCache = TransactionSwiftDataCache(modelContainer: modelContainer)
        self.bankAccountCache = BankAccountSwiftDataCache(modelContainer: modelContainer)
        self.bankAccountService = BankAccountsService(networkClient: networkClient, bankAccountCache: bankAccountCache)
        self.transactionBackup = TransactionBackupCache(modelContainer: modelContainer)
        self.transactionService = TransactionsService(
            userAccountId: userAccountId,
            networkClient: networkClient,
            transactionBackupCache: transactionBackup,
            transactionCache: transactionCache,
            bankAccountsService: bankAccountService
        )
        self.categoryService = CategoriesService(networkClient: networkClient, categoriesCache: categoriesCache)
    }

    static func make(modelContainer: ModelContainer) async throws -> AppDependencies {
        let networkClient = NetworkClient()
        let bankAccountService = BankAccountsService(networkClient: networkClient, bankAccountCache: BankAccountSwiftDataCache(modelContainer: modelContainer))

        let bankAccount = try await bankAccountService.fetchBankAccount()
        let userAccountId = bankAccount?.id ?? 0

        return AppDependencies(
            userAccountId: userAccountId,
            modelContainer: modelContainer,
            networkClient: networkClient
        )
    }
}

