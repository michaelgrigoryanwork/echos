//
//  SceneDelegate.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupSceneDelegate(windowScene: windowScene)
    }
}

extension SceneDelegate {
    func setupSceneDelegate(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = AppStateStorage.shared.shouldShowMainApp ? VCFactory.mainViewController() : VCFactory.onboardingIntro()
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func showMainScreen() {
        let main = VCFactory.mainViewController()
        let nav = UINavigationController(rootViewController: main)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
