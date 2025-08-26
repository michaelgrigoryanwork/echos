//
//  OnboardingStepsViewController.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class OnboardingStepsViewController: BaseViewController {
    // MARK: - Views
    private lazy var contentView: OnboardingStepsView = {
        let view = OnboardingStepsView()
        view.onActionButtonTap { [weak self] in

        }
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: OnboardingStepsViewModel
    
    // MARK: - Init
    
    init(viewModel: OnboardingStepsViewModel) {
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
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
}
