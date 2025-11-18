//
//  MoodViewController.swift
//  Echos
//
//  Created by Emma on 18.11.25.
//

import UIKit

class MoodViewController: BaseViewController {
    
    // MARK: - Views
    private lazy var contentView: MoodContanierView = {
        let view = MoodContanierView()
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: MoodViewControllerViewModel
    
    // MARK: - Init
    
    init(viewModel: MoodViewControllerViewModel) {
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
        view.backgroundColor = .black60
        setupClosure()
        
    }
    
    private func setupClosure() {
        contentView.onSendTapped = {[weak self] in
            guard let self else { return }
            self.closeView()
        }
        contentView.onDismiss = { [weak self] in
            guard let self else { return }
            self.closeView()
        }
    }
    
    private func closeView() {
        self.dismiss(animated: false)
    }
}
