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
    
    func getPhraseOfDay(_ date: EchosDate) -> PhraseOfDay?
    func storePhraseOfDay(_ phraseOfDay: PhraseOfDay)
}

final class PhrasesDatabaseHandler {
    private var phrasesKey: UDDatabaseHandler.ConfigKey {
        return .phrases
    }
    
    private var phrasesOfDayKey: UDDatabaseHandler.ConfigKey {
        return .phrasesOfDay
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
        guard let data: Data = databaseHandler.getValueFromUD(key: phrasesKey) else {
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
            databaseHandler.storeValueInUD(value: data, key: phrasesKey)
        } catch {
            print("Failed to encode Phrases: \(error)")
        }
    }
}

extension PhrasesDatabaseHandler {
    func getPhraseOfDay(_ date: EchosDate) -> PhraseOfDay? {
        return getPhrasesOfDay().first(where: { $0.date == date })
    }

    func storePhraseOfDay(_ phraseOfDay: PhraseOfDay) {
        do {
            var phrasesOfDays = getPhrasesOfDay()
            phrasesOfDays.append(phraseOfDay)
            let data = try encoder.encode(phrasesOfDays)
            databaseHandler.storeValueInUD(value: data, key: phrasesOfDayKey)
        } catch {
            print("Failed to encode Phrase Of Day: \(error)")
        }
    }
    
    private func getPhrasesOfDay() -> [PhraseOfDay] {
        guard let data: Data = databaseHandler.getValueFromUD(key: phrasesOfDayKey) else {
            return []
        }
        do {
            let phrases = try decoder.decode([PhraseOfDay].self, from: data)
            return phrases
        } catch {
            print("Failed to decode Phrases: \(error)")
            return []
        }
    }
}
