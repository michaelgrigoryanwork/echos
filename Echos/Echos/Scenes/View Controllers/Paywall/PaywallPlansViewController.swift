//
//  PaywallPlansViewController.swift
//  Echos
//
//  Created by Emma on 13.11.25.
//

import UIKit
import Combine

class PaywallPlansViewController: BaseViewController {
    private lazy var contentView: PaywallPlansContainerView = {
        let view = PaywallPlansContainerView()
        view.backgroundColor = .echosBeige
        return view
    }()
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: PaywallPlansViewModel
    
    // MARK: - Init
    
    init(viewModel: PaywallPlansViewModel) {
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
        viewModel.$paywallModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paywallModel in
                guard let self, let paywallModel else {
                    return
                }
                self.contentView.setData(
                    paywallModel: paywallModel,
                    selectedProduct: self.viewModel.selectedProduct
                )
            }
            .store(in: &cancellables)
        
        viewModel.$selectedProduct
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                guard let self, let product, self.viewModel.paywallModel != nil else {
                    return
                }
                self.contentView.selectProduct(product: product)
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
        
        contentView.productSelectTrigger = { [weak self] product in
            guard let self, let product else { return }
            self.viewModel.selectProduct(product)
            self.contentView.selectProduct(product: product)
        }
    }
}

private extension PaywallPlansViewController {
    func showNextPage() {
        let vc = VCFactory.onboardingLoading()
        push(vc)
    }
}
