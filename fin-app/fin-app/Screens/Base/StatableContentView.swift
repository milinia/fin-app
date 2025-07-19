//
//  StatableContentView.swift
//  fin-app
//
//  Created by Evelina on 16.07.2025.
//

import Foundation
import SwiftUI

struct StatableContentView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.DataType) -> Content
    var retryAction: () -> Void
    
    var body: some View {
        switch source.state {
            case .loading:
                ProgressView()
            case .completed(let data):
                content(data)
            case .failed(let error):
                ErrorView(message: error.localizedDescription, action: retryAction)
            case .idle:
                EmptyView()
        }
    }
}
