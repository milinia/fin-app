//
//  AnalysisView.swift
//  fin-app
//
//  Created by Evelina on 10.07.2025.
//

import SwiftUI

struct AnalysisView: View {
    
    @ObservedObject var model: AnalysisViewModel
    @State var transactions: [GroupedTransactions] = []
    @State var startDate: Date = Date.dayMonthAgo
    @State var endDate: Date = Date.startOfTomorrow
    @State var totalAmount: Decimal = 0
    @State var sortBy: SortBy = .byDate
    @State var initialTransactions: [GroupedTransactions] = []
    
    private var direction: Direction
    
    init(model: AnalysisViewModel, direction: Direction) {
        self.model = model
        self.direction = direction
    }
    
    var body: some View {
        AnalysisViewControllerRepresentableView(transactions: $transactions,
                                                totalAmount: $totalAmount,
                                                startDate: $startDate,
                                                endDate: $endDate,
                                                sortBy: $sortBy)
        .onChange(of: [startDate, endDate]) {
            Task {
                await updateTransactions()
            }
        }
        .onChange(of: sortBy) {
            Task {
                if sortBy == .byDate {
                    transactions = initialTransactions
                } else {
                    transactions.sort { $0.amount > $1.amount }
                }
            }
        }
        .task {
            await updateTransactions()
        }
    }
    
    private func updateTransactions() async {
        await model.fetchTransactions(direction: direction,
                                      startOfThePeriod: startDate,
                                      endOfThePeriod: endDate)
        transactions = model.groupedTransactions
        initialTransactions = model.groupedTransactions
        totalAmount = model.totalAmount
    }
}

#Preview {
    AnalysisView(model: AnalysisViewModel(transactionService: TransactionsService()), direction: .income)
}
