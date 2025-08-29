//
//  OnboardingIntroViewController.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class OnboardingIntroViewController: BaseViewController {
    // MARK: - Views
    private lazy var contentView: OnboardingIntroView = {
        let view = OnboardingIntroView()
        view.onActionButtonTap { [weak self] in
            self?.showNextPage()
        }
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: OnboardingIntroViewModelProtocol
    
    // MARK: - Init
    
    init(viewModel: OnboardingIntroViewModelProtocol) {
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
private extension OnboardingIntroViewController {
    func showNextPage() {
        let vc = VCFactory.onboardingStepsViewController()
        push(vc)
    }
}
