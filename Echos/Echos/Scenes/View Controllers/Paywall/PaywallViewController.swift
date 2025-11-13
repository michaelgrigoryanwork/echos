//
//  PaywallViewController.swift
//  Echos
//
//  Created by Emma on 10.11.25.
//

import UIKit

class PaywallViewController: BaseViewController {
    
    private lazy var contentView: PaywallContanierView = {
        let view = PaywallContanierView()
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: PaywallViewModel
    
    // MARK: - Init
    
    init(viewModel: PaywallViewModel) {
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
            
        }
        
        contentView.viewOthersTrigger = { [weak self] in
            guard let self else { return }
            
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
