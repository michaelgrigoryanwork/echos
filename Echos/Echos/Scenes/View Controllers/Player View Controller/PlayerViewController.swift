//
//  PlayerViewController.swift
//  Echos
//
//  Created by Emma on 14.11.25.
//

import UIKit

class PlayerViewController: BaseViewController {
    
    private lazy var contentView: PlayerView = {
        let view = PlayerView()
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: PlayerViewModel
    
    // MARK: - Init
    
    init(viewModel: PlayerViewModel) {
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
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
