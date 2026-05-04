//
//  BaseViewController.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    var shouldHideNavigationBar: Bool {
        return false
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            shouldHideNavigationBar,
            animated: animated
        )
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
extension BaseViewController {
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
    
    func setupNavigationRightBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let rightImage = EchosImage.Main.navigationRightIcon
        let button = UIButton(type: .system)
        button.setImage(rightImage, for: .normal)
        button.tintColor = .echosBlack80
        let rightItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [rightItem]
    }
    
    func navigationBarIsHidden(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
    
    func setNavigationTitle(
        _ text: String,
        font: UIFont = EchosFont.helveticaMedium(size: 20).uiFont,
        color: UIColor = .echosBlack
    ) {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.textAlignment = .center
        label.numberOfLines = 1
        
        // Чтобы размерился по контенту
        label.sizeToFit()
        navigationItem.titleView = label
    }
    
    func showAlert(error: Error) {
        let alertController = UIAlertController(title: "Error.title".localized(),
                                                message: error.localizedDescription,
                                                preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .actionSheet : .alert)
        let okAction = UIAlertAction(title: "Error.ok".localized(), style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
