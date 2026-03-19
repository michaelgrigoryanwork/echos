//
//  RemoteConfigManager.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

final class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    private let remoteConfigHandler: RemoteConfigHandlerProtocol
    private let databaseHandler: UDDatabaseHandlerProtocol
    
    private init(
        remoteConfigHandler: RemoteConfigHandlerProtocol = RemoteConfigHandler(),
        databaseHandler: UDDatabaseHandlerProtocol = UDDatabaseHandler()
    ) {
        self.remoteConfigHandler = remoteConfigHandler
        self.databaseHandler = databaseHandler
    }
    
    func start() {
        Task {
            do {
                try await remoteConfigHandler.fetchAndActivate()
                storeRemoteConfigValues()
                print("RemoteConfigManager started")
            } catch {
                print("RemoteConfigManager start failed with error: \(error)")
            }
        }
    }
}

private extension RemoteConfigManager {
    func storeRemoteConfigValues() {
        UDDatabaseHandler.ConfigKey.allCases.forEach { key in
            switch key {
            case .phrases, .phrasesOfDay:
                let value: Data? = remoteConfigHandler.getValue(forKey: key.rawValue)
                databaseHandler.storeValueInUD(value: value, key: key)
            }
        }
    }
}
