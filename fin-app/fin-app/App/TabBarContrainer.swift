//
//  File.swift
//  fin-app
//
//  Created by Evelina on 20.07.2025.
//

import Foundation
import SwiftUI
import SwiftData
import Lottie

struct TabBarContainer: View {
    let modelContainer: ModelContainer
    @State private var dependencies: AppDependencies?
    @State private var animationDidFinish: Bool = false

    var body: some View {
        VStack {
            if !animationDidFinish {
                LottieView(animation: .named("pig.json"))
                    .animationDidFinish { completed in
                        animationDidFinish = true
                    }
                    .playing()
            }
            if animationDidFinish {
                Group {
                    if let deps = dependencies {
                        TabBar(dependencies: deps)
                    } else {
                        ProgressView()
                    }
                }
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
