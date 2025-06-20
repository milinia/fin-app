//
//  TransactionsListView.swift
//  fin-app
//
//  Created by Evelina on 16.06.2025.
//

import SwiftUI

struct TransactionsListView: View {

    @ObservedObject var model: TransactionsListModel
    
    @State private var isShowingHistory = false
    
    private let direction: Direction
    
    init(direction: Direction, model: TransactionsListModel) {
        self.direction = direction
        self.model = model
    }
    
    private var totalSection: some View {
        Section {
            HStack {
                Text(Strings.TransactionsListView.total)
                Spacer()
                
                let amount = String(describing: model.totalAmount).amountFormatted()
                let currency = CurrencySign(rawValue: model.transactions.first?.account.currency ?? "USD")?.symbol ?? "$"
                Text("\(amount) \(currency)")
            }
        }
    }
    
    private var operationsSection: some View {
        Section(header: Text(Strings.TransactionsListView.operations)) {
            ForEach(model.transactions) { transaction in
                HStack {
                    if direction == .outcome {
                        CircleEmojiIcon(emoji: String(transaction.category.emoji))
                    }
                    OperationItemView(operation: transaction)
                }
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    direction == .income ? viewDimensions[.listRowSeparatorLeading] :
                        viewDimensions[.listRowSeparatorLeading] + 28
                }
            }
        }
    }
    
    private var addTransactionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // добавить транзакцию
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accent)
                        .clipShape(Circle())
                        .frame(width: 56, height: 56)
                }
                .padding(.bottom, 16)
                .padding(.trailing, 16)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    totalSection
                    operationsSection
                }
                addTransactionButton
            }
            .navigationDestination(isPresented: $isShowingHistory) {
                HistoryView(model: HistoryModel(), direction: direction)
            }
            .navigationTitle(direction == .income ? Strings.TransactionsListView.incomeTitle : Strings.TransactionsListView.outcomeTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingHistory = true
                    }) {
                        AppIcons.TransactionsListViewIcons.clocks.image
                    }
                }
            }
        }
        .onAppear {
            model.fetchTransactions(direction: direction)
        }
    }
}

#Preview {
    TransactionsListView(direction: .income, model: TransactionsListModel())
}
