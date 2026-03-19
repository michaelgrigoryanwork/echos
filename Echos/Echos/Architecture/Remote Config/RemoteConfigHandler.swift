//
//  RemoteConfigHandler.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigHandlerProtocol {
    func fetchAndActivate() async throws
    func getValue<T: Any>(forKey key: String) -> T?
}

final class RemoteConfigHandler {
    private let remoteConfig: RemoteConfig
    
    init(
        remoteConfig: RemoteConfig = .remoteConfig(),
        settings: RemoteConfigSettings = .echosSettings()
    ) {
        self.remoteConfig = remoteConfig
        self.remoteConfig.configSettings = settings
    }
}

extension RemoteConfigHandler: RemoteConfigHandlerProtocol {
    func fetchAndActivate() async throws {
        try await remoteConfig.fetchAndActivate()
    }
    
    func getValue<T: Any>(forKey key: String) -> T?  {
        return remoteConfig.configValue(forKey: key).dataValue as? T
    }
}

private extension RemoteConfigSettings {
    static func echosSettings(
        minimumFetchInterval: TimeInterval = .zero
    ) -> RemoteConfigSettings {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = minimumFetchInterval
        return settings
    }
}
