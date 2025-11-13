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
        view.onActionButtonTap { [weak self] index in
            if self?.viewModel.isLastStep == true {
                self?.showNextPage()
            } else {
                self?.viewModel.selectStep(index: index) {
                    self?.contentView.selectNextStep()
                }
            }
        }
        view.onSegmentedProgressBarHighlightChanged { [weak self] index in
            self?.viewModel.selectStep(index: index)
        }
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: OnboardingStepsViewModelProtocol
    
    // MARK: - Init
    
    init(viewModel: OnboardingStepsViewModelProtocol) {
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
    
    override func setupData() {
        super.setupData()
        contentView.setupData(
            items: viewModel.getSteps(),
            totalSegmentsCount: viewModel.getSteps().count
        )
    }
    
    override func setupCallback() {
        super.setupCallback()
    }
}

// MARK: - Navigation
private extension OnboardingStepsViewController {
    func showNextPage() {
//        let vc = VCFactory.onboardingLoading()
        let vc = VCFactory.paywallViewController()
        push(vc)
    }
}
