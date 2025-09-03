//
//  AuthorizationViewModel.swift
//  Echos
//
//  Created by Michael Grigoryan on 03.09.25.
//

import Foundation

protocol AuthorizationViewModelProtocol {
    // MARK: - Methods
    func loginWithApple(userId: String, email: String?, completion: (() -> Void)?)
    func loginWithGoogle(userId: String?, email: String?, completion: (() -> Void)?)
}

final class AuthorizationViewModel {
    
}

// MARK: - Protocol
extension AuthorizationViewModel: AuthorizationViewModelProtocol {
    func loginWithApple(userId: String, email: String?, completion: (() -> Void)?) {
        
    }
    
    func loginWithGoogle(userId: String?, email: String?, completion: (() -> Void)?) {

    }
}
