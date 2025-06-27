//
//  CurrencySelectorView.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import SwiftUI

struct CurrencySelectorView: View {
    
    @Binding var selectedCurrency: CurrencySign
    @Binding var showingCurrencyPopover: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text(Strings.MyBalanceView.currency)
                .font(.system(size: 13, weight: .medium, design: .default))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            
            Divider()
            
            let currencies = CurrencySign.allCases
            ForEach(currencies, id: \.self) { currency in
                Text("\(currency.text) \(currency.symbol)")
                    .foregroundColor(Color.purpleAccent)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        selectedCurrency = currency
                        showingCurrencyPopover.toggle()
                    }
                if currency != currencies.last {
                    Divider()
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding()
    }
}
