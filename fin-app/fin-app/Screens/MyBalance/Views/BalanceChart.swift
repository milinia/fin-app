//
//  BalanceChart.swift
//  fin-app
//
//  Created by Evelina on 23.07.2025.
//

import SwiftUI
import Charts

struct TransactionStatistics: Identifiable, Equatable {
    let id: UUID = UUID()
    let date: Date
    let balance: Double
}

struct BalanceChart: View {
    
    @State private var rawSelectedDate: Date?
    @Binding var isDayStatistics: Bool
    
    private var selectedDate: Date? {
        get { rawSelectedDate }
        set { rawSelectedDate = newValue }
    }
    
    private var maxValue: Double {
        statistics.map(\.balance).max() ?? 0
    }
    
    var statistics: [TransactionStatistics]
    
    var body: some View {
        Chart {
            ForEach(statistics) { stat in
                BarMark(
                    x: .value("Date", stat.date, unit: isDayStatistics ? .day : .month),
                    y: .value("Amount", abs(stat.balance))
                )
                .foregroundStyle(stat.balance >= 0 ? Color.green : Color.red)
                .cornerRadius(10)
            }
            
            if let selectedDate = selectedDate {
                let day = isDayStatistics ? Calendar.current.startOfDay(for: selectedDate) : Calendar.current.startOfMonth(for: selectedDate)
                if let value = statistics.first(where: { Calendar.current.isDate($0.date, inSameDayAs: day) }) {
                    RuleMark(x: .value("Selected", selectedDate, unit: isDayStatistics ? .day : .month))
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .lineStyle(.init(lineWidth: 1))
                        .offset(yStart: -5)
                        .zIndex(-1)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled)
                        ) {
                            VStack {
                                Text(
                                    isDayStatistics
                                    ? value.date.formatted(.dateTime.day().month(.wide))
                                    : value.date.formatted(.dateTime.month(.wide).year(.defaultDigits))
                                )
                                Text(formatBalance(value.balance))
                                    .fontWeight(.bold)
                                    .foregroundStyle(value.balance >= 0 ? Color.green : Color.red)
                                
                            }
                            .padding(6)
                            .background(Color.gray.opacity(0.08))
                            .cornerRadius(8)
                        }
                    }
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let dateValue = value.as(Date.self) {
                        Text(
                            isDayStatistics
                            ? dateValue.formatted(.dateTime.day().month(.twoDigits))
                            : dateValue.formatted(.dateTime.month(.abbreviated)) 
                        )
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks { _ in }
        }
        .chartXSelection(value: $rawSelectedDate)
    }
    
    func formatBalance(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
