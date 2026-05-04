//
//  TrialPaywallViewController.swift
//  Echos
//
//  Created by Emma on 10.11.25.
//

import UIKit
import Combine

class TrialPaywallViewController: BaseViewController {
    
    private lazy var contentView: TrialPaywallContainerView = {
        let view = TrialPaywallContainerView()
        view.backgroundColor = .echosBeige
        return view
    }()
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: TrialPaywallViewModel
    
    // MARK: - Init
    
    init(viewModel: TrialPaywallViewModel) {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .echosBeige
        setupNavigationRightBar()
        bindContentView()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.$selectedProduct
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedProduct in
                guard let self, let selectedProduct else {
                    return
                }
                self.contentView.setData(
                    selectedProduct: selectedProduct
                )
            }
            .store(in: &cancellables)
        
        viewModel.$purchaseResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let result else {
                    return
                }
                if let error = result.error {
                    self.showAlert(error: error)
                } else {
                    self.showNextPage()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isPurchaseInProcess
            .receive(on: DispatchQueue.main)
            .sink { isPurchaseInProcess in
                UIApplication.shared.showLoading(isPurchaseInProcess)
            }
            .store(in: &cancellables)
        
        viewModel.$purchaseError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self, let error else {
                    return
                }
                self.showAlert(error: error)
            }
            .store(in: &cancellables)
    }
    
    private func bindContentView() {
        contentView.actionButtonTrigger = { [weak self] in
            guard let self else { return }
            self.viewModel.purchaseSubscription()
        }
        
        contentView.viewOthersTrigger = { [weak self] in
            guard let self else { return }
            let vc = VCFactory.paywallPlansViewController()
            self.push(vc)
        }

        contentView.termsAndConditionsTrigger = { [weak self] in
            guard let self else { return }
            
        }
        
        contentView.restorPurchasesTrigger = { [weak self] in
            guard let self else { return }
            self.viewModel.restoreSubscription()
        }
        
        contentView.privacyPolicyTrigger = { [weak self] in
            guard let self else { return }
            
        }
    }
}

private extension TrialPaywallViewController {
    func showNextPage() {
        let vc = VCFactory.onboardingLoading()
        push(vc)
    }
}
