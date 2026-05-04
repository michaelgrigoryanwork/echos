//
//  AuthorizationViewModel.swift
//  Echos
//
//  Created by Michael Grigoryan on 03.09.25.
//

import Foundation

protocol AuthorizationViewModelProtocol {
    // MARK: - Methods
    func loginWithApple(name: String?, userName: String?, userId: String?, email: String?, completion: (() -> Void)?)
    func loginWithGoogle(name: String?, userName: String?, userId: String?, email: String?, completion: (() -> Void)?)
}

final class AuthorizationViewModel {
    
    private let storage: AppStateStorage
    
    init(storage: AppStateStorage = .shared) {
        self.storage = storage
    }
}

// MARK: - Protocol
extension AuthorizationViewModel: AuthorizationViewModelProtocol {
    func loginWithApple(name: String?, userName: String?, userId: String?, email: String?, completion: (() -> Void)?) {
        storage.setLoggedIn(userId: userId ?? "", middleName: name ?? "", name: userName ?? "", email: email ?? "", provider: .apple)
        storage.isOnboardingPassed = true
        completion?()
    }
    
    func loginWithGoogle(name: String?, userName: String?, userId: String?, email: String?, completion: (() -> Void)?) {
        storage.setLoggedIn(userId: userId ?? "", middleName: name ?? "", name: userName ?? "", email: email ?? "", provider: .google)
        storage.isOnboardingPassed = true
        completion?()
    }
}
