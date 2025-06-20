//
//  HistoryView.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var model: HistoryModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var sortBy: SortOperations = .byDate
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var dateChanged: EditingDateField = .start
    
    private var direction: Direction
    
    init(model: HistoryModel, direction: Direction) {
        self.model = model
        self.direction = direction
    }
    
    private var commonInfoView: some View {
        Section {
            HStack {
                Text(Strings.HistoryView.start)
                Spacer()
                Text(model.formatDate(date: model.startOfThePeriod))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 11)
                    .background(RoundedRectangle(cornerRadius: 6)
                            .fill(Color.lightGreen))
                    .onTapGesture {
                        selectedDate = model.startOfThePeriod
                        showDatePicker = true
                        dateChanged = .start
                    }
            }
            
            HStack {
                Text(Strings.HistoryView.end)
                Spacer()
                Text(model.formatDate(date: model.endOfThePeriod))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                        .fill(Color.lightGreen)
                    )
                    .onTapGesture {
                        selectedDate = model.endOfThePeriod
                        showDatePicker = true
                        dateChanged = .end
                    }
            }
            
            HStack {
                Text(Strings.HistoryView.sort)
                Spacer()
                Text(sortBy.title)
                    .onTapGesture {
                        sortBy = sortBy == .byAmount ? .byDate : .byAmount
                        model.sortOperation(by: sortBy)
                    }
            }
            
            HStack {
                Text(Strings.HistoryView.sum)
                Spacer()
                let currencySymbol = CurrencySign(rawValue: model.transactions.first?.account.currency ?? "USD")?.symbol ?? "$"
                Text("\(model.totalAmount) \(currencySymbol)")
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
    
    var body: some View {
        NavigationStack {
            List {
                commonInfoView
                operationsSection
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            AppIcons.HistoryViewIcons.backPurple.image
                            Text(Strings.HistoryView.back)
                        }
                        .tint(Color.purpleAccent)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                       
                    }) {
                        AppIcons.HistoryViewIcons.file.image
                    }
                }
            }
            .navigationTitle(Strings.HistoryView.title)
        }
        .onAppear {
            model.fetchTransactions(direction: direction)
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("",
                           selection: $selectedDate,
                           displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                        
                Button(Strings.HistoryView.done) {
                    showDatePicker = false
                    
                    switch dateChanged {
                    case .start:
                        model.setStartOfThePeriod(selectedDate)
                    case .end:
                        model.setEndOfThePeriod(selectedDate)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HistoryView(model: HistoryModel(), direction: .outcome)
}
