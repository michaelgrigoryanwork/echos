//
//  AuthorizationViewController.swift
//  Echos
//
//  Created by Michael Grigoryan on 03.09.25.
//

import UIKit
import AuthenticationServices
import FirebaseCore
import GoogleSignIn

final class AuthorizationViewController: BaseViewController {
    // MARK: - Views
    private lazy var contentView: AuthorizationView = {
        let view = AuthorizationView()
        view.onAuthWithAppleButtonTap { [weak self] in
            self?.loginWithApple()
        }
        view.onAuthWithGoogleButtonTap { [weak self] in
            self?.loginWithGoogle()
        }
        return view
    }()
    
    // MARK: - Properties
    override var shouldHideNavigationBar: Bool {
        return true
    }
    
    private let viewModel: AuthorizationViewModelProtocol
    
    // MARK: - Init
    
    init(viewModel: AuthorizationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
}

// MARK: - Navigation
private extension AuthorizationViewController {
    func showNextPage() {
        guard
            let windowScene = view.window?.windowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
        
        sceneDelegate.showMainScreen()
    }
}

// MARK: - Login With Apple
extension AuthorizationViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private func loginWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {

        guard let cred = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        let userId = cred.user
        let email = cred.email
        let givenName = cred.fullName?.givenName
        let familyName = cred.fullName?.familyName
        if email != nil || givenName != nil || familyName != nil {
            let profile = AppleCachedProfile(userId: userId,
                                             givenName: givenName,
                                             familyName: familyName,
                                             email: email)
            AppleProfileCache.shared.save(profile)
        }
        let cached = AppleProfileCache.shared.load(userId: userId)

        let finalEmail = email ?? cached?.email
        let finalGiven = givenName ?? cached?.givenName
        let finalFamily = familyName ?? cached?.familyName
        viewModel.loginWithApple(
            name: finalGiven,
            userName: finalFamily,
            userId: userId,
            email: finalEmail
        ) { [weak self] in
            self?.showNextPage()
        }
    }

    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In failed: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// MARK: - Login With Google
extension AuthorizationViewController {
    private func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {
                return
            }
            let fullName   = user.profile?.name
            let givenName  = user.profile?.givenName
            let email      = user.profile?.email

            let displayName = fullName ?? givenName

            self?.viewModel.loginWithGoogle(
                name: "",
                userName: displayName,
                userId: user.userID,
                email: email
            ) { [weak self] in
                self?.showNextPage()
            }
        }
    }
}
