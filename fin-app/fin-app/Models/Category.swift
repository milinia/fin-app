//
//  Category.swift
//  fin-app
//
//  Created by Evelina on 07.06.2025.
//

import Foundation

struct Category: Codable, Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let emoji: Character
    let isIncome: Direction
    
    private enum CodingKeys: String, CodingKey, Hashable {
        case id
        case name
        case emoji
        case isIncome
    }
    
    init (id: Int, name: String, emoji: Character, isIncome: Direction) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let emojiString = try container.decode(String.self, forKey: .emoji)
        guard let emojiChar = emojiString.first, emojiString.count == 1 else {
            throw DecodingError.dataCorruptedError(forKey: .emoji, in: container, debugDescription: "Emoji must be a single character")
        }
        emoji = emojiChar
        
        isIncome = try container.decode(Direction.self, forKey: .isIncome)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(String(emoji), forKey: .emoji)
        try container.encode(isIncome, forKey: .isIncome)
    }
}
