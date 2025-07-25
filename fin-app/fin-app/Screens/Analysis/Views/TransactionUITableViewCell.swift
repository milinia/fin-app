//
//  TransactionUITableViewCell.swift
//  fin-app
//
//  Created by Evelina on 10.07.2025.
//

import Foundation
import UIKit

class TransactionUITableViewCell: UITableViewCell {
    
    private enum Constants {
        static let circleViewSize: CGSize = CGSize(width: 22, height: 22)
        static let circleViewCornerRadius: CGFloat = 8
        static let contentInset: CGFloat = 16
        static let arrowWidth: CGFloat = 16
    }
    
    private lazy var transactionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var transactionAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var transactionPercentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.5, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        
        if let image = UIImage(named: AppIcons.TransactionsListViewIcons.arrowForward.rawValue)?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.tintColor = .gray
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
    }
    
    func configure(with transaction: GroupedTransactions) {
        emojiLabel.text = String(transaction.category.emoji)
        transactionTitleLabel.text = transaction.category.name
        transactionAmountLabel.text = String(describing: transaction.amount).amountFormatted()
        transactionPercentLabel.text = String(describing: transaction.percentage) + "%"
    }
    
    private func setupUI() {
        setupEmojiView()
        
        [circleView, transactionTitleLabel, transactionPercentLabel, transactionAmountLabel, arrowButton].forEach({ addSubview($0) })
        
        setupConstraints()
    }
    

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInset),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: Constants.circleViewSize.width),
            circleView.heightAnchor.constraint(equalToConstant: Constants.circleViewSize.height),
            
            transactionTitleLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: Constants.contentInset),
            transactionTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInset),
            transactionTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInset),
            transactionTitleLabel.trailingAnchor.constraint(equalTo: transactionAmountLabel.leadingAnchor, constant: -Constants.contentInset),
            
            arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInset),
//            arrowButton.widthAnchor.constraint(equalToConstant: 11),
//            arrowButton.heightAnchor.constraint(equalToConstant: 22),
            
            transactionPercentLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInset),
            transactionPercentLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -Constants.contentInset),
            
            transactionAmountLabel.topAnchor.constraint(equalTo: transactionPercentLabel.bottomAnchor, constant: Constants.contentInset),
            transactionAmountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInset),
            transactionAmountLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -Constants.contentInset)
            
        ])
        
        transactionTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        transactionTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        transactionAmountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        transactionPercentLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    }
    
    private func setupEmojiView() {
        circleView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.9),
            emojiLabel.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.9),
        ])
    }
}
