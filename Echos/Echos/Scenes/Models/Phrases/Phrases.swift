//
//  Phrases.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

struct Phrases: Codable {
    let data: [Phrase]
    
    enum CodingKeys: CodingKey {
        case data
    }
}

extension Phrases {
    static let key = "phrases"
}

struct Phrase: Codable {
    let id: Int
    let message: PhraseMessage?
    let highlight: PhraseMessage?
    
    enum CodingKeys: CodingKey {
        case id
        case message
        case highlight
    }
}

struct PhraseMessage: Codable {
    let en: String?
    let ru: String?
    
    enum CodingKeys: CodingKey {
        case en
        case ru
    }
}
