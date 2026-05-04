//
//  UIApplication+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 04.05.26.
//

import UIKit

// MARK: - Loading indicator
extension UIApplication {
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.getTopViewController() else { return }
            if show {
                guard !topVC.view.subviews.contains(where: {
                    $0.isKind(of: DimmedView.self)
                }) else {
                    topVC.view.subviews.forEach {
                        if $0.isKind(of: DimmedView.self) {
                            $0.removeFromSuperview()
                        }
                    }
                    return
                }

                let loadingView = self.createLoadingView()
                loadingView.layoutIfNeeded()
                topVC.view.addSubview(loadingView)

                loadingView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            } else {
                UIApplication.shared.currentWindow?.subviews.forEach {
                    if $0.isKind(of: DimmedView.self) {
                        $0.removeFromSuperview()
                    }
                }
                topVC.view.subviews.forEach {
                    if $0.isKind(of: DimmedView.self) {
                        $0.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    private func createLoadingView() -> DimmedView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.color = .echosViolet
        indicator.hidesWhenStopped = true
        
        let dimmedView = DimmedView()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .echosBeige.withAlphaComponent(0.9)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 20
        
        dimmedView.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        backgroundView.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(28)
        }
        return dimmedView
    }

    private final class DimmedView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .black.withAlphaComponent(0.15)
        }
        
        required init?(coder: NSCoder) {
            fatalError("initWithCoder is not available for \(Self.description())")
        }
    }
    
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.moduleName == "Echos" ? nav.topViewController : nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController, presented.moduleName == "Echos" {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    private var currentWindow: UIWindow? {
        return self.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
