//
//  fin_appApp.swift
//  fin-app
//
//  Created by Evelina on 07.06.2025.
//

import SwiftUI
import SwiftData

@main
struct fin_appApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CategoryCacheModel.self, TransactionCacheModel.self, TransactionBackupModel.self, BankAccount.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabBarContainer(modelContainer: sharedModelContainer)
        }
        .modelContainer(sharedModelContainer)
    }
}
