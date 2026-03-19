//
//  PhrasesDatabaseHandler.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

protocol PhrasesDatabaseHandlerProtocol {
    func getPhrases() -> Phrases?
    func storePhrases(_ phrases: Phrases)
}

final class PhrasesDatabaseHandler {
    private var key: UDDatabaseHandler.ConfigKey {
        return .phrases
    }
    
    private let databaseHandler: UDDatabaseHandlerProtocol
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        databaseHandler: UDDatabaseHandlerProtocol = UDDatabaseHandler(),
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.databaseHandler = databaseHandler
        self.decoder = decoder
        self.encoder = encoder
    }
}

extension PhrasesDatabaseHandler: PhrasesDatabaseHandlerProtocol {
    func getPhrases() -> Phrases? {
        guard let data: Data = databaseHandler.getValueFromUD(key: key) else {
            return nil
        }
        do {
            let phrases = try decoder.decode(Phrases.self, from: data)
            return phrases
        } catch {
            print("Failed to decode Phrases: \(error)")
            return nil
        }
    }
    
    func storePhrases(_ phrases: Phrases) {
        do {
            let data = try encoder.encode(phrases)
            databaseHandler.storeValueInUD(value: data, key: key)
        } catch {
            print("Failed to encode Phrases: \(error)")
        }
    }
}
