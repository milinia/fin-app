//
//  TabBar.swift
//  fin-app
//
//  Created by Evelina on 16.06.2025.
//

import SwiftUI
import SwiftData

struct TabBar: View {
    
    @StateObject private var dependencies: AppDependencies

    init(modelContainer: ModelContainer) {
        _dependencies = StateObject(wrappedValue: AppDependencies(modelContainer: modelContainer))
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                Tab(Strings.TabBar.outcome, image: AppIcons.TabBarIcons.outcome.rawValue) {
                    TransactionsListView(
                        direction: .outcome,
                        model: TransactionsListModel(
                            transactionsService: dependencies.transactionService
                        )
                    )
                }
                Tab(Strings.TabBar.income, image: AppIcons.TabBarIcons.income.rawValue) {
                    TransactionsListView(
                        direction: .income,
                        model: TransactionsListModel(
                            transactionsService: dependencies.transactionService
                        )
                    )
                }
                Tab(Strings.TabBar.balance, image: AppIcons.TabBarIcons.balance.rawValue) {
                    MyBalanceView(
                        model: MyBalanceModel(
                            bankAccountService: dependencies.bankAccountService
                        )
                    )
                }
                Tab(Strings.TabBar.category, image: AppIcons.TabBarIcons.category.rawValue) {
                    MyCategoriesView(
                        model: MyCategoriesViewModel(
                            categoriesService: dependencies.categoryService,
                            fuzzySearchHelper: FuzzySearchHelper()
                        )
                    )
                }
                Tab(Strings.TabBar.settings, image: AppIcons.TabBarIcons.settings.rawValue) {
                    EmptyView()
                }
            }
            .environmentObject(dependencies)
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
