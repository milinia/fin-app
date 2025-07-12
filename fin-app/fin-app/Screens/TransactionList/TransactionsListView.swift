//
//  TransactionsListView.swift
//  fin-app
//
//  Created by Evelina on 16.06.2025.
//

import SwiftUI

enum ActiveModal: Equatable {
    case create(BankAccount)
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

    @ObservedObject var model: TransactionsListModel
    
    @StateObject private var manageTransactionViewModel: ManageTransactionViewModel
    @State private var isShowingHistory = false
    @State private var activeModal: ActiveModal?
    
    private let direction: Direction
    
    init(direction: Direction, model: TransactionsListModel) {
        self.direction = direction
        self.model = model
        
        self._manageTransactionViewModel = StateObject(
                    wrappedValue: ManageTransactionViewModel(
                        categoriesService: CategoriesService(),
                        transactionsService: model.transactionsService
                    )
                )
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
    
    private var addTransactionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if let bankAccount = model.transactions.first?.account {
                        activeModal = .create(bankAccount)
                    }
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
            .onChange(of: activeModal, {
                model.fetchTransactions(direction: direction)
            })
            .navigationDestination(isPresented: $isShowingHistory) {
                HistoryView(model: HistoryModel(transactionsService: TransactionsService()), direction: direction)
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
        .fullScreenCover(item: $activeModal) { modal in
            switch modal {
            case .create(let bankAccount):
                ManageTransactionView(
                    state: .create(direction, bankAccount),
                    model: manageTransactionViewModel
                )
            case .edit(let transaction):
                ManageTransactionView(
                    state: .edit(direction, transaction),
                    model: manageTransactionViewModel
                )
            }
        }
    }
}

#Preview {
    TransactionsListView(direction: .income, model: TransactionsListModel(transactionsService: TransactionsService()))
}
