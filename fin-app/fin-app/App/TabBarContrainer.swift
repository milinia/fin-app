//
//  File.swift
//  fin-app
//
//  Created by Evelina on 20.07.2025.
//

import Foundation
import SwiftUI
import SwiftData

struct TabBarContainer: View {
    let modelContainer: ModelContainer
    @State private var dependencies: AppDependencies?

    var body: some View {
        Group {
            if let deps = dependencies {
                TabBar(dependencies: deps)
            } else {
                ProgressView()
            }
        }
        .task {
            if dependencies == nil {
                do {
                    dependencies = try await AppDependencies.make(modelContainer: modelContainer)
                } catch {
                    print("Ошибка при создании зависимостей: \(error)")
                }
            }
        }
    }
}
