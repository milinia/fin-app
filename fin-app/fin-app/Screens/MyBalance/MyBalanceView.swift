//
//  MyBalanceView.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import SwiftUI

struct MyBalanceView: View {
    
    @ObservedObject var model: MyBalanceModel
    
    @State private var showingCurrencyPopover = false
    @State private var state: MyBalanceViewState = .view
    @FocusState private var isBalanceEntering: Bool
    @State private var isBalanceHidden: Bool = false
    
    private var balanceView: some View {
       HStack {
           Text(Strings.MyBalanceView.moneyEmoji)
               .padding(.trailing, 8)
           Text(Strings.MyBalanceView.balance)
           Spacer()
           HStack(spacing: 4) {
               TextField("", text: $model.balanceString)
                   .keyboardType(.decimalPad)
                   .foregroundColor(isBalanceHidden ? state.balanceTextBackgroundColor : .primary)
                   .multilineTextAlignment(.trailing)
                   .frame(minWidth: 50, maxWidth: 100, alignment: .trailing)
                   .focused($isBalanceEntering)
                   .allowsHitTesting(state.isTextFieldEditable)
                   .onChange(of: model.balanceString, {
                       let digits = model.balanceString.filter("-0123456789".contains)
                       model.updateBalance(digits)
                   })
               Text(model.selectedCurrency.symbol)
                   .foregroundColor(isBalanceHidden ? state.balanceTextBackgroundColor : .primary)
           }
           .spoiler(isVisible: $isBalanceHidden)
        }
       .padding(16)
       .background(state.balanceTextBackgroundColor)
       .overlay(
           Color.black.opacity(showingCurrencyPopover ? 0.3 : 0)
       )
       .cornerRadius(8)
    }
    
    private var currencyView: some View {
       HStack {
           Text(Strings.MyBalanceView.currency)
           Spacer()
           Text(model.selectedCurrency.symbol)
               .foregroundStyle(state.balanceInfoTextColor)
           if state == .edit {
               Image(systemName: "chevron.right")
                   .resizable()
                   .frame(width: 7, height: 11)
                   .foregroundStyle(state.balanceInfoTextColor)
           }
        }
       .contentShape(Rectangle())
       .onTapGesture {
           guard state == .edit else { return }
           showingCurrencyPopover.toggle()
       }
       .padding(16)
       .background(state.currencyTextColor)
       .overlay(
           Color.black.opacity(showingCurrencyPopover ? 0.3 : 0)
       )
       .cornerRadius(8)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showingCurrencyPopover {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                }
                ScrollView {
                    VStack {
                        balanceView
                            .padding(.horizontal, 16)
                        currencyView
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .refreshable {
                    model.fetchBankAccount()
                }
                
                if state == .edit && showingCurrencyPopover {
                    Spacer()
                    CurrencySelectorView(selectedCurrency: $model.selectedCurrency,
                                         showingCurrencyPopover: $showingCurrencyPopover)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                model.fetchBankAccount()
            }
            .onTapGesture {
                if showingCurrencyPopover {
                    showingCurrencyPopover.toggle()
                }
                if isBalanceEntering {
                    isBalanceEntering = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        state = state == .edit ? .view : .edit
                        if state == .view {
                            isBalanceEntering = false
                            model.updateBankAccount()
                        } else {
                            isBalanceHidden = false
                        }
                    }) {
                        Text(state.leadingNavigationButtonTitle)
                            .tint(Color.purpleAccent)
                    }
                }
            }
            .navigationTitle(Strings.MyBalanceView.title)
        }
        .onShake {
            isBalanceHidden.toggle()
        }
    }
}

#Preview {
    MyBalanceView(model: MyBalanceModel(bankAccountService: BankAccountsService()))
}
