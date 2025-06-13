//
//  TransactionsFileCache.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

enum FileCacheError: Error {
    case invalidFilePath
    case cannotReadFile
    case cannotWriteFile
}

protocol TransactionsFileCacheProtocol {
    var transactions: [Int: Transaction] { get }
    func addTransaction(transaction: Transaction)
    func deleteTransaction(with id: Int)
    func saveTransactions(to path: String) throws
    func loadTransactions(from path: String) throws
}

final class TransactionsFileCache: TransactionsFileCacheProtocol {
    private(set) var transactions: [Int: Transaction] = [:]
    
    func addTransaction(transaction: Transaction) {
        guard transactions[transaction.id] == nil else { return }
        transactions[transaction.id] = transaction
    }
    
    func deleteTransaction(with id: Int) {
        transactions.removeValue(forKey: id)
    }
    
    func saveTransactions(to path: String) throws {
        let url = URL(fileURLWithPath: path)
        let transactionsArray = Array(transactions.values)
        let jsonData = transactionsArray.map({ $0.jsonObject })
        
        guard let outputStream = OutputStream(url: url, append: true) else {
            throw FileCacheError.cannotWriteFile
        }
        
        outputStream.open()
        defer {
            outputStream.close()
        }
        
        let writtenBytes = JSONSerialization.writeJSONObject(jsonData, to: outputStream, options: [.prettyPrinted], error: nil)
        
        if writtenBytes == 0 {
            throw FileCacheError.cannotWriteFile
        }
    }
    
    func loadTransactions(from path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        guard let inputStream = InputStream(url: url) else {
            throw FileCacheError.cannotReadFile
        }
        
        inputStream.open()
        defer {
            inputStream.close()
        }
        
        guard let data = try JSONSerialization.jsonObject(with: inputStream) as? [[String: Any]] else {
            throw FileCacheError.cannotReadFile
        }
        
        data.forEach({
            if let transaction = Transaction.parse(jsonObject: $0) {
                transactions[transaction.id] = transaction
            }
        })
    }
}
