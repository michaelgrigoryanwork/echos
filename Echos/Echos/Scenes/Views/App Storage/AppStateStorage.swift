//
//  AppStateStorage.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import Foundation

enum AuthProvider: String, Codable {
    case apple
    case google
}

struct UserSession: Codable {
    let userID: String
    let name: String
    let email: String
    let provider: AuthProvider
}

final class AppStateStorage {
    
    static let shared = AppStateStorage()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let userSession       = "userSession"
        static let onboardingPassed  = "onboardingPassed"
    }
    
    // MARK: - Onboarding
    
    var isOnboardingPassed: Bool {
        get { defaults.bool(forKey: Keys.onboardingPassed) }
        set { defaults.set(newValue, forKey: Keys.onboardingPassed) }
    }
    
    // MARK: - User session
    
    var userSession: UserSession? {
        get {
            guard let data = defaults.data(forKey: Keys.userSession) else { return nil }
            return try? JSONDecoder().decode(UserSession.self, from: data)
        }
        set {
            if let newValue {
                let data = try? JSONEncoder().encode(newValue)
                defaults.set(data, forKey: Keys.userSession)
            } else {
                defaults.removeObject(forKey: Keys.userSession)
            }
        }
    }
    
    var isLoggedIn: Bool {
        userSession != nil
    }
    
    var shouldShowMainApp: Bool {
        isLoggedIn && isOnboardingPassed
    }
    
    // MARK: - Helpers
    
    func setLoggedIn(userId: String, name: String, email: String, provider: AuthProvider) {
        userSession = UserSession(userID: userId, name: name, email: email, provider: provider)
    }
    
    func logout() {
        userSession = nil
    }
}
