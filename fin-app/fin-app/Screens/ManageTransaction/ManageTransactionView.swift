//
//  ManageTransactionView.swift
//  fin-app
//
//  Created by Evelina on 11.07.2025.
//

import SwiftUI

struct ManageTransactionView: View {
    
    @ObservedObject var model: ManageTransactionViewModel
    @State var state: ManageTransactionScreenState
    @Environment(\.dismiss) var dismiss
    @State private var selectedTime = Date()
    @State private var selectedDate = Date()
    @State private var amount: String = ""
    @State private var transactionComment: String = ""
    @State private var selectedCategory: Category?
    @State private var showAlert = false
    @FocusState private var isAmountEntering: Bool
    
    init(state: ManageTransactionScreenState, model: ManageTransactionViewModel) {
        self.state = state
        self.model = model
        
        _selectedCategory = State(initialValue: state.selectedCategory)
        _amount = State(initialValue: state.amountPlaceholder)
        _transactionComment = State(initialValue: state.initialComment)
    }
    
    private var categoryPickerView: some View {
        Menu {
            ForEach(model.categories, id: \.id) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category.name)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedCategory?.name ?? "")
                    .foregroundColor(.lightGray)
                    .padding(.trailing, 8)
                AppIcons.TransactionsListViewIcons.arrowForward.image
                    .frame(width: 16, height: 36)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
    }
    
    private var commonInfoView: some View {
        Section {
            HStack {
                Text(Strings.ManageTransactionView.categories)
                Spacer()
                categoryPickerView
            }
            
            HStack {
                Text(Strings.ManageTransactionView.sum)
                Spacer()
                TextField("", text: $amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .focused($isAmountEntering)
                    .onChange(of: amount, {
                        amount = amount.filter("-0123456789,.".contains)
                    })
            }
            
            HStack {
                Text(Strings.ManageTransactionView.date)
                Spacer()
                DatePicker("",
                           selection: $selectedDate,
                           in: ...Date(),
                           displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.lightGreen))
            }
            
            HStack {
                Text(Strings.ManageTransactionView.time)
                Spacer()
                DatePicker("",
                           selection: $selectedTime,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.lightGreen))
            }
            
            HStack {
                TextField(state.commentPlaceholder, text: $transactionComment)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                commonInfoView

                if state.isDeleteButtonEnabled {
                    Button(role: .destructive) {
                        if let transaction = state.transaction {
                            model.deleteTransaction(transaction: transaction)
                            dismiss()
                        }
                    } label: {
                        Text(state.deleteButtonTitle)
                    }
                    .contentShape(Rectangle())
                }
            }
            .alert(Strings.ManageTransactionView.error, isPresented: $showAlert) {
                Button(Strings.ManageTransactionView.ok, role: .cancel) { }
            } message: {
                Text(Strings.ManageTransactionView.emptyFields)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text(Strings.ManageTransactionView.cancel)
                            .tint(Color.purpleAccent)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if !isSavingAllowed() {
                            showAlert = true
                        } else {
                            switch state {
                            case .create(_, let bankAccount):
                                model.addTransaction(account: bankAccount,
                                                     category: selectedCategory,
                                                     amount: Decimal(string: amount) ?? 0,
                                                     comment: transactionComment)

                            case .edit(_, let transaction):
                                model.editTransaction(transaction: transaction,
                                                      newCategory: selectedCategory,
                                                      newAmount: Decimal(string: amount) ?? 0,
                                                      comment: transactionComment)
                            }
                            dismiss()
                        }
                    }) {
                        Text(state.rightBarButtonTitle)
                            .tint(Color.purpleAccent)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(state.title)
            .task {
                await model.fetchCategories(by: state.direction)
            }
        }
    }

    
    private func isSavingAllowed() -> Bool {
       if selectedCategory != nil, amount != "" {
            return true
        }
        return false
    }
}

#Preview {
    ManageTransactionView(state: ManageTransactionScreenState.create(.income, BankAccount(id: 4, name: "", balance: 67, currency: "RUB")), model: ManageTransactionViewModel(categoriesService: CategoriesService(), transactionsService: TransactionsService()))
}
