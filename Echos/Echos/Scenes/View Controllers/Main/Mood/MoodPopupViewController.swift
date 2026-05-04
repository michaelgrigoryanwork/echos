//
//  MoodPopupViewController.swift
//  Echos
//
//  Created by Emma on 18.11.25.
//

import UIKit

class MoodPopupViewController: BaseViewController {
    
    // MARK: - Views
    private lazy var contentView: MoodPopupContanierView = {
        let view = MoodPopupContanierView()
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: MoodPopupViewControllerViewModel
    private let mood: Mood
    
    // MARK: - Init
    
    init(viewModel: MoodPopupViewControllerViewModel, mood: Mood) {
        self.viewModel = viewModel
        self.mood = mood
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
        setuContanierView()
    }
    
    private func setuContanierView() {
        contentView.seletionMood(mood)
    }
    
    private func setupClosure() {
        contentView.onSendTapped = {[weak self] text, mood in
            guard let self else { return }
            NotificationCenter.default.post(
                    name: .moodDidSave,
                    object: nil,
                    userInfo: [
                        MoodNotificationKeys.mood: mood,
                        MoodNotificationKeys.text: text as Any
                    ]
                )
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
