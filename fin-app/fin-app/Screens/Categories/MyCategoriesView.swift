//
//  MyCategoriesView.swift
//  fin-app
//
//  Created by Evelina on 01.07.2025.
//

import SwiftUI

struct MyCategoriesView: View {
    
    @ObservedObject var model: MyCategoriesViewModel
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(Strings.MyCategoriesView.category) {
                    ForEach(model.categoriesToView) { category in
                        HStack {
                            CircleEmojiIcon(emoji: String(category.emoji))
                            Text(category.name)
                            Spacer()
                        }
                        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                            viewDimensions[.listRowSeparatorLeading] + 28
                        }
                    }
                }
            }
            .onChange(of: searchText) { _, newValue in
                withAnimation {
                    model.filterCategories(by: newValue)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle(Strings.MyCategoriesView.title)
            .task {
                await model.fetchCategories()
            }
        }
    }
}

#Preview {
    MyCategoriesView(model: MyCategoriesViewModel(categoriesService: CategoriesService(), fuzzySearchHelper: FuzzySearchHelper()))
}
