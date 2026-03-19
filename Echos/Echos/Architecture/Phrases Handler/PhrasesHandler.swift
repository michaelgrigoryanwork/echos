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
    private var phrases: Phrases? {
        return databaseHandler.getPhrases()
    }
    
    private let databaseHandler: PhrasesDatabaseHandlerProtocol
    
    init(databaseHandler: PhrasesDatabaseHandlerProtocol = PhrasesDatabaseHandler()) {
        self.databaseHandler = databaseHandler
    }
}

extension PhrasesHandler: PhrasesHandlerProtocol {
    func getPhraseOfTheDay() -> Phrase? {
        return phrases?.data.randomElement()
    }
}
