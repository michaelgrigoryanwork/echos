//
//  PaywallPlansViewController.swift
//  Echos
//
//  Created by Emma on 13.11.25.
//

import UIKit

class PaywallPlansViewController: BaseViewController {
    
    private lazy var contentView: PaywallPlansContanieView = {
        let view = PaywallPlansContanieView()
        return view
    }()
    
    // MARK: - Properties
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
        contentView.backgroundColor = .echosBeige
        setupNavigationRightBar()
        setupClosure()
    }
    
    
    private func setupClosure() {
        contentView.tryFreeTrigger = { [weak self] in
            guard let self else { return }
            let vc = VCFactory.onboardingLoading()
            push(vc)
        }
        
        contentView.termsAndConditionsTrigger = { [weak self] in
            guard let self else { return }
            
        }
        
        contentView.restorPurchasesTrigger = { [weak self] in
            guard let self else { return }
            
        }
        
        contentView.privacyPolicyTrigger = { [weak self] in
            guard let self else { return }
            
        }
    }
    
}
