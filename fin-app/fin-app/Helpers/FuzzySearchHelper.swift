//
//  FuzzySearchHelper.swift
//  fin-app
//
//  Created by Evelina on 04.07.2025.
//

import Foundation

protocol FuzzySearchHelperProtocol {
    func fuzzySearch(for categories: [Category], with pattern: String) -> [Category]
}

final class FuzzySearchHelper: FuzzySearchHelperProtocol {
    
    struct SearchResult {
        let weight: Double
        let matchIndex: Int
    }
    
    func fuzzySearch(for categories: [Category], with pattern: String) -> [Category] {
        let lowercasedPattern = pattern.lowercased()
        
        return categories
            .compactMap { category -> (Category, SearchResult)? in
                guard let result = bestMatchScore(category.name.lowercased(), pattern: lowercasedPattern) else { return nil }
                return (category, result)
            }
            .sorted { $0.1.weight < $1.1.weight }
            .map { $0.0 }
    }
    
    private func bestMatchScore(_ text: String, pattern: String) -> SearchResult? {
        guard hasCommonCharacters(text, pattern) else {
            return nil
        }
        let n = text.count
        let m = pattern.count
        if m == 0 || n == 0 || m > n { return nil }

        let maxDistance = 3
        var bestScore = Double.infinity
        var bestIndex = 0

        let textArray = Array(text)

        let desiredLocation = text.firstIndex(of: pattern.first!)?.utf16Offset(in: text) ?? 0

        for i in 0...(n - m) {
            let substring = String(textArray[i..<i + m])
            let dist = levenshteinDistance(substring, pattern)
            if dist <= maxDistance {
                let positionPenalty = Double(abs(i - desiredLocation)) / Double(m)
                let score = Double(dist) + positionPenalty

                if score < bestScore {
                    bestScore = score
                    bestIndex = i
                }
            }
        }

        return bestScore == Double.infinity ? nil : SearchResult(weight: bestScore, matchIndex: bestIndex)
    }
    
    private func hasCommonCharacters(_ text: String, _ pattern: String) -> Bool {
        let textSet = Set(text)
        let patternSet = Set(pattern)
        return !textSet.isDisjoint(with: patternSet)
    }
    
    private func levenshteinDistance(_ a: String, _ b: String) -> Int {
        let a = Array(a)
        let b = Array(b)
        var dist = [[Int]](repeating: [Int](repeating: 0, count: b.count + 1), count: a.count + 1)

        for i in 0...a.count { dist[i][0] = i }
        for j in 0...b.count { dist[0][j] = j }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]
                } else {
                    dist[i][j] = min(
                        dist[i-1][j] + 1,
                        dist[i][j-1] + 1,
                        dist[i-1][j-1] + 1
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }
}
