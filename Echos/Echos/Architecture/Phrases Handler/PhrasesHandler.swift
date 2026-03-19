//
//  PhrasesHandler.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

protocol PhrasesHandlerProtocol {
    func getPhraseOfTheDay() -> Phrase?
}

final class PhrasesHandler {
    private(set) var phraseOfDay: PhraseOfDay?
    
    private let databaseHandler: PhrasesDatabaseHandlerProtocol
    
    init(databaseHandler: PhrasesDatabaseHandlerProtocol = PhrasesDatabaseHandler()) {
        self.databaseHandler = databaseHandler
        retrieveData()
    }
    
    private func retrieveData() {
        let date = EchosDate(date: Date())
        if databaseHandler.getPhraseOfDay(date) == nil, let phrase = databaseHandler.getPhrases()?.data.randomElement()  {
            databaseHandler.storePhraseOfDay(
                PhraseOfDay(date: date, phrase: phrase)
            )
        }
        phraseOfDay = databaseHandler.getPhraseOfDay(date)
    }
}

extension PhrasesHandler: PhrasesHandlerProtocol {
    func getPhraseOfTheDay() -> Phrase? {
        return phraseOfDay?.phrase
    }
}
