//
//  BaseViewController.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    // MARK: - Setup
    func setupViews() {
        // TODO: - Don't forget to override.
    }
    
    func setupConstraints() {
        // TODO: - Don't forget to override.
    }
    
    func setupData() {
        // TODO: - Don't forget to override.
    }
    
    func setupCallback() {
        // TODO: - Don't forget to override.
    }
}

// MARK: - Setup
private extension BaseViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let image = EchosImage.Main.navigationBack
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
        navigationBar.tintColor = .echosBlack80
        navigationItem.backButtonDisplayMode = .minimal
    }
}
