//
//  PhraseOfDay.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

struct PhraseOfDay: Codable {
    let date: EchosDate
    let phrase: Phrase
}
