//
//  OnboardingLoadingViewController.swift
//  Echos
//
//  Created by Michael Grigoryan on 02.09.25.
//

import UIKit

final class OnboardingLoadingViewController: BaseViewController {
    // MARK: - Views
    private lazy var contentView: OnboardingLoadingView = {
        let view = OnboardingLoadingView()
        return view
    }()
    
    // MARK: - Properties
    override var shouldHideNavigationBar: Bool {
        return true
    }
    
    private let viewModel: OnboardingLoadingViewModelProtocol
    
    // MARK: - Init
    
    init(viewModel: OnboardingLoadingViewModelProtocol) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.startLoading { [weak self] _ in
            self?.showNextPage()
        }
    }
}

// MARK: - Navigation
private extension OnboardingLoadingViewController {
    func showNextPage() {

    }
}
