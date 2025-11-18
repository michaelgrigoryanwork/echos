//
//  MainViewController.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import UIKit

class MainViewController: BaseViewController {
    
    // MARK: - Views
    private lazy var contentView: MainViewContanier = {
        let view = MainViewContanier()
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: MainViewModel
    
    // MARK: - Init
    
    init(viewModel: MainViewModel) {
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
        view.backgroundColor = .mainBackground
        setInAppStorage()
        setupClosure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarIsHidden(true)
    }
    
    
    func setInAppStorage() {
        contentView.setupName(name: viewModel.returnUserName())
    }
    
    func setupClosure() {
        contentView.onCommentTapped = { [weak self] in
            guard let self else { return }
            let vc = VCFactory.moodPopup()
            presentScale(vc)
        }
        
        contentView.onListenTapped = { [weak self] in
            guard let self else { return }
            let vc = VCFactory.playerViewController()
            push(vc)
        }
    }
}
