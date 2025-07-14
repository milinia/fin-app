//
//  AnalysisViewControllerRepresentableView.swift
//  fin-app
//
//  Created by Evelina on 06.07.2025.
//

import Foundation
import SwiftUI
import UIKit

struct AnalysisViewControllerRepresentableView: UIViewControllerRepresentable {
    typealias UIViewControllerType = AnalysisViewController
    
    @Binding var transactions: [GroupedTransactions]
    @Binding var totalAmount: Decimal
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var sortBy: SortBy
    
    func makeUIViewController(context: Context) -> AnalysisViewController {
        let view = AnalysisViewController()
        view.onDateChange = { start, end in
            startDate = start
            endDate = end
        }
        view.onSortChange = { sortBy in
            self.sortBy = sortBy
        }
        return view
    }
    
    func updateUIViewController(_ viewController: AnalysisViewController, context: Context) {
        viewController.updateView(with: transactions, totalAmount: totalAmount)
    }
}




