//
//  AppleProfileCache.swift
//  Echos
//
//  Created by Emma on 10.02.26.
//

import Foundation

struct AppleCachedProfile: Codable {
    let userId: String
    let givenName: String?
    let familyName: String?
    let email: String?
}

final class AppleProfileCache {
    static let shared = AppleProfileCache()
    private init() {}

    private func key(for userId: String) -> String {
        "apple_profile_\(userId)"
    }

    func save(_ profile: AppleCachedProfile) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(profile) else { return }
        try? KeychainStore.shared.save(data: data, account: key(for: profile.userId))
    }

    func load(userId: String) -> AppleCachedProfile? {
        do {
            let data = try KeychainStore.shared.read(account: key(for: userId))
            return try JSONDecoder().decode(AppleCachedProfile.self, from: data)
        } catch {
            return nil
        }
    }

    func delete(userId: String) {
        try? KeychainStore.shared.delete(account: key(for: userId))
    }
}

