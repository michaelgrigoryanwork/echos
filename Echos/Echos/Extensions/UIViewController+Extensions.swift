//
//  UIViewController+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

extension UIViewController {
    // MARK: - Methods
    func push(
        _ viewController: UIViewController,
        animated: Bool = true
    ) {
        guard let navigationController else {
            fatalError("Could not find navigation controller to push!")
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func modal(
        _ viewController: UIViewController,
        onNavigationController: Bool = false,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if onNavigationController, let navigationController {
            navigationController.present(viewController, animated: animated, completion: completion)
        } else {
            present(viewController, animated: animated, completion: completion)
        }
    }
}
