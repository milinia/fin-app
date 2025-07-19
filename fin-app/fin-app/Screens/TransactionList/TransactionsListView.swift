//
//  TransactionsListView.swift
//  fin-app
//
//  Created by Evelina on 16.06.2025.
//

import SwiftUI

enum ActiveModal: Equatable {
    case create
    case edit(Transaction)
}

extension ActiveModal: Identifiable {
    var id: String {
        switch self {
        case .create:
            return "create"
        case .edit(let transaction):
            return "edit-\(transaction.id)"
        }
    }
}

struct TransactionsListView: View {
    
    @EnvironmentObject var dependencies: AppDependencies

    @ObservedObject var model: TransactionsListModel
    @State private var isShowingHistory = false
    @State private var activeModal: ActiveModal?
    
    private let direction: Direction
    
    init(direction: Direction, model: TransactionsListModel) {
        self.direction = direction
        self.model = model
    }
    
    private func totalSection(transaction: Transaction?, totalAmount: Decimal) -> some View {
        Section {
            HStack {
                Text(Strings.TransactionsListView.total)
                Spacer()
                
                let amount = String(describing: totalAmount).amountFormatted()
                let currency = CurrencySign(rawValue: transaction?.account.currency ?? "USD")?.symbol ?? "$"
                Text("\(amount) \(currency)")
            }
        }
    }
    
    private func operationsSection(transactions: [Transaction]) -> some View {
        Section(header: Text(transactions.isEmpty ? Strings.TransactionsListView.noOperations : Strings.TransactionsListView.operations)) {
            ForEach(transactions) { transaction in
                HStack {
                    if direction == .outcome {
                        CircleEmojiIcon(emoji: String(transaction.category.emoji))
                    }
                    OperationItemView(operation: transaction)
                }
                .onTapGesture {
                    activeModal = .edit(transaction)
                    
                }
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    direction == .income ? viewDimensions[.listRowSeparatorLeading] :
                        viewDimensions[.listRowSeparatorLeading] + 28
                }
            }
        }
    }
    
    private func addTransactionButton(transaction: Transaction?) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    activeModal = .create
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
    
    private func contentView(transactions: [Transaction], totalAmount: Decimal) -> some View {
        NavigationStack {
            ZStack {
                List {
                    totalSection(transaction: transactions.first, totalAmount: totalAmount)
                    operationsSection(transactions: transactions)
                }
                addTransactionButton(transaction: transactions.first)
            }
            .onChange(of: activeModal, {
                Task {
                    await model.fetchTransactions(direction: direction)
                }
            })
            .navigationDestination(isPresented: $isShowingHistory) {
                HistoryView(model:
                                HistoryViewModel(
                                    transactionsService: dependencies.transactionService),
                            direction: direction
                )
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
        .fullScreenCover(item: $activeModal) { modal in
            switch modal {
            case .create:
                ManageTransactionView(
                    state: .create(direction),
                    model: ManageTransactionViewModel(
                        categoriesService: dependencies.categoryService,
                        transactionsService: dependencies.transactionService
                    )
                )
            case .edit(let transaction):
                ManageTransactionView(
                    state: .edit(direction, transaction),
                    model: ManageTransactionViewModel(
                        categoriesService: dependencies.categoryService,
                        transactionsService: dependencies.transactionService
                    )
                )
            }
        }
    }
    
    var body: some View {
        StatableContentView(source: model) { transactions, totalAmount in
            contentView(
                transactions: transactions,
                totalAmount: totalAmount
            )
        } retryAction: {
            Task {
                await model.fetchTransactions(direction: direction)
            }
        }
        .task {
            await model.fetchTransactions(direction: direction)
        }
    }
}
