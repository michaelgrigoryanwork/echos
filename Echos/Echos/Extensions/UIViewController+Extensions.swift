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
    
    func presentScale(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        vc.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        vc.view.alpha = 0
        
        present(vc, animated: false) {
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut) {
                vc.view.alpha = 1
                vc.view.transform = .identity
            }
        }
    }
}
