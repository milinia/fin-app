//
//  HistoryView.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import SwiftUI
import UIKit

struct HistoryView: View {
    
    @ObservedObject var model: HistoryModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var sortBy: SortOperations = .byDate
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    @State private var selectedDate = Date()
    @State private var dateChanged: EditingDateField = .start
    @State private var startFieldPosition: CGRect = .zero
    @State private var endFieldPosition: CGRect = .zero
    
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
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                startFieldPosition = geo.frame(in: .global)
                            }
                    })
                    .onTapGesture {
                        selectedDate = model.startOfThePeriod
                        showStartDatePicker = true
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
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                endFieldPosition = geo.frame(in: .global)
                            }
                    })
                    .onTapGesture {
                        selectedDate = model.endOfThePeriod
                        showEndDatePicker = true
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
    
    private var datePicker: some View {
        VStack {
            DatePicker("",
                       selection: $selectedDate,
                       displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()
                    
            Button(Strings.HistoryView.done) {
                showEndDatePicker = false
                showStartDatePicker = false
                
                switch dateChanged {
                case .start:
                    model.setStartOfThePeriod(selectedDate)
                case .end:
                    model.setEndOfThePeriod(selectedDate)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(3)
        .shadow(radius: 1)
        .padding(.horizontal, 30)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                
                if showStartDatePicker || showEndDatePicker {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                showStartDatePicker = false
                                showEndDatePicker = false
                            }
                        }
                }
                
                if showStartDatePicker {
                    datePicker
                        .position(x: UIScreen.main.bounds.midX, y: startFieldPosition.maxY + 2 * startFieldPosition.height - 8)
                }
                if showEndDatePicker {
                    datePicker
                        .position(x: UIScreen.main.bounds.midX, y: endFieldPosition.maxY + 2 * endFieldPosition.height - 8)
                }
            }
        }
        .onAppear {
            model.fetchTransactions(direction: direction)
        }
    }
}

#Preview {
    HistoryView(model: HistoryModel(), direction: .outcome)
}
