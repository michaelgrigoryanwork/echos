//
//  UDDatabaseHandler.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

protocol UDDatabaseHandlerProtocol {
    func storeValueInUD<T: Any>(value: T?, key: UDDatabaseHandler.ConfigKey)
    func getValueFromUD<T: Any>(key: UDDatabaseHandler.ConfigKey) -> T?
}

final class UDDatabaseHandler {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

extension UDDatabaseHandler: UDDatabaseHandlerProtocol {
    func storeValueInUD<T>(value: T?, key: UDDatabaseHandler.ConfigKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getValueFromUD<T>(key: UDDatabaseHandler.ConfigKey) -> T? {
        return userDefaults.value(forKey: key.rawValue) as? T
    }
}

extension UDDatabaseHandler {
    enum ConfigKey: String, CaseIterable {
        case phrases = "phrases"
        case phrasesOfDay = "phrases_of_day"
    }
}
