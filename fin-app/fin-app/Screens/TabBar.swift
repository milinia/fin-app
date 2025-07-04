//
//  TabBar.swift
//  fin-app
//
//  Created by Evelina on 16.06.2025.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                Tab(Strings.TabBar.outcome, image: AppIcons.TabBarIcons.outcome.rawValue) {
                    TransactionsListView(direction: .outcome, model: TransactionsListModel(transactionsService: TransactionsService()))
                }
                Tab(Strings.TabBar.income, image: AppIcons.TabBarIcons.income.rawValue) {
                    TransactionsListView(direction: .income, model: TransactionsListModel(transactionsService: TransactionsService()))
                }
                Tab(Strings.TabBar.balance, image: AppIcons.TabBarIcons.balance.rawValue) {
                    MyBalanceView(model: MyBalanceModel(bankAccountService: BankAccountsService()))
                }
                Tab(Strings.TabBar.category, image: AppIcons.TabBarIcons.category.rawValue) {
                    MyCategoriesView(model: MyCategoriesViewModel(categoriesService: CategoriesService(), fuzzySearchHelper: FuzzySearchHelper()))
                }
                Tab(Strings.TabBar.settings, image: AppIcons.TabBarIcons.settings.rawValue) {
                    EmptyView()
                }
            }
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor.white
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3))
                .edgesIgnoringSafeArea(.horizontal)
                .offset(y: -49)
        }
        .background(Color.white)
    }
}

#Preview {
    TabBar()
}
