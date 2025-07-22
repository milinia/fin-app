//
//  InfoView.swift
//  fin-app
//
//  Created by Evelina on 11.07.2025.
//

import Foundation
import UIKit

protocol InfoViewDelegate: AnyObject {
    func dateDidChange(startDate: Date, endDate: Date)
    func sortDidChange(by sort: SortBy)
}

class InfoView: UIView {
    
    var sum: String {
        get {
            return sumLabel.text ?? ""
        }
        set {
            sumLabel.text = newValue.amountFormatted()
        }
    }
    
    weak var delegate: InfoViewDelegate?
    
    private lazy var startTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.AnalysisView.periodBegin
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var endTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.AnalysisView.periodEnd
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.AnalysisView.sum
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.HistoryView.sort
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var sortPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.date = Date.dayMonthAgo
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.date = Date.startOfTomorrow
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let hstack1 = UIStackView(arrangedSubviews: [startTitleLabel, startDatePicker])
        hstack1.axis = .horizontal
        hstack1.distribution = .fillEqually
        hstack1.translatesAutoresizingMaskIntoConstraints = false
        
        let hstack2 = UIStackView(arrangedSubviews: [endTitleLabel, endDatePicker])
        hstack2.axis = .horizontal
        hstack2.distribution = .fillEqually
        hstack2.translatesAutoresizingMaskIntoConstraints = false
        
        let hstack3 = UIStackView(arrangedSubviews: [sumTitleLabel, sumLabel])
        hstack3.axis = .horizontal
        hstack3.distribution = .fillEqually
        hstack3.translatesAutoresizingMaskIntoConstraints = false
        
        let hstack4 = UIStackView(arrangedSubviews: [sortTitleLabel, sortPicker])
        hstack3.axis = .horizontal
        hstack3.distribution = .fillProportionally
        hstack3.translatesAutoresizingMaskIntoConstraints = false
        
        let vstack = UIStackView(arrangedSubviews: [hstack1, makeDivider(), hstack2, makeDivider(), hstack3, makeDivider(), hstack4])
        vstack.axis = .vertical
        vstack.spacing = 8
        vstack.distribution = .equalCentering
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vstack)
        
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            vstack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vstack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vstack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 0.3)
           ])
        return divider
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        if sender == startDatePicker && startDatePicker.date > endDatePicker.date {
            endDatePicker.setDate(startDatePicker.date, animated: true)
        } else if sender == endDatePicker && endDatePicker.date < startDatePicker.date {
            startDatePicker.setDate(endDatePicker.date, animated: true)
        }
        delegate?.dateDidChange(startDate: startDatePicker.date, endDate: endDatePicker.date)
    }
}

extension InfoView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        SortBy.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SortBy.allCases[row].title
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.sortDidChange(by: SortBy.allCases[row])
    }
}
