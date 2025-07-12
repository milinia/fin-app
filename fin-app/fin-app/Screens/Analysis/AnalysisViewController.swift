//
//  AnalysisViewController.swift
//  fin-app
//
//  Created by Evelina on 10.07.2025.
//

import Foundation
import UIKit

class AnalysisViewController: UIViewController {
    
    private var transactions: [GroupedTransactions] = []
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    var onDateChange: ((Date, Date) -> Void)?
    var onSortChange: ((SortBy) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.AnalysisView.title
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var transactionLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.TransactionsListView.operations.uppercased()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var transactionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 8
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        setupScrollView()
        setupNavigationTitle()
        setupInfoView()
        setupTransactionLabel()
        setupTableView()
    }
    
    func updateView(with transactions: [GroupedTransactions], totalAmount: Decimal) {
        self.transactions = transactions
        transactionsTableView.reloadData()
        infoView.sum = String(describing: totalAmount)
        
        DispatchQueue.main.async {
            self.tableViewHeightConstraint?.constant = CGFloat(self.transactions.count) * 85
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        view.addSubview(transactionLabel)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: transactionLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGroupedBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemGroupedBackground
        navigationController?.navigationBar.tintColor = .purpleAccent
    }
    
    private func setupNavigationTitle() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupInfoView() {
        view.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoView.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
    
    private func setupTransactionLabel() {
        view.addSubview(transactionLabel)
        
        NSLayoutConstraint.activate([
            transactionLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 20),
            transactionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupTableView() {
        transactionsTableView.dataSource = self
        transactionsTableView.delegate = self
        transactionsTableView.register(TransactionUITableViewCell.self, forCellReuseIdentifier: String(describing: TransactionUITableViewCell.self))
        transactionsTableView.isScrollEnabled = false
        
        contentView.addSubview(transactionsTableView)
        
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transactionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transactionsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
            
        tableViewHeightConstraint = transactionsTableView.heightAnchor.constraint(equalToConstant: 85)
        tableViewHeightConstraint?.isActive = true
    }
}

extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = transactionsTableView.dequeueReusableCell(withIdentifier:
                                                                    String(describing: TransactionUITableViewCell.self)) as? TransactionUITableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension AnalysisViewController: InfoViewDelegate {
    func sortDidChange(by sort: SortBy) {
        onSortChange?(sort)
    }
    
    func dateDidChange(startDate: Date, endDate: Date) {
        onDateChange?(startDate, endDate)
    }
}
