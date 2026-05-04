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
    private let en: String?
    private let ru: String?
    
    func get(locale: Locale = .current) -> String? {
        switch locale.language.languageCode {
        case .russian:
            return ru
        default:
            return en
        }
    }
    
    enum CodingKeys: CodingKey {
        case en
        case ru
    }
}
