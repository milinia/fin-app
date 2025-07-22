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
    
    private func contentView(categories: [Category]) -> some View {
        NavigationView {
            List {
                Section(Strings.MyCategoriesView.category) {
                    ForEach(categories) { category in
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
        }
    }
    
    var body: some View {
        StatableContentView(source: model, content: { categories in
            contentView(categories: categories)
        }, retryAction: {
            Task {
                await model.fetchCategories()
            }
        })
        .task {
            await model.fetchCategories()
        }
    }
}
