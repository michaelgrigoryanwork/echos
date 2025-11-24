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
    
    private var moodObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setInAppStorage()
        setupClosure()
        setupNotificationCenter()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarIsHidden(true)
//        MoodDayStorage.shared.resetAll()
    }
    
    deinit {
        if let moodObserver {
            NotificationCenter.default.removeObserver(moodObserver)
        }
    }
    
    func setupNotificationCenter() {
        moodObserver = NotificationCenter.default.addObserver(
            forName: .moodDidSave,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            guard let mood = notification.userInfo?[MoodNotificationKeys.mood] as? Mood else {
                return
            }
            let text = notification.userInfo?[MoodNotificationKeys.text] as? String
            
            self.handleMood(mood, text: text)
        }
    }
    
    
    func setInAppStorage() {
        contentView.setupName(name: viewModel.returnUserName())
    }
    
    func setupClosure() {
        contentView.settingsTrigger = {[weak self] in
            guard let self else { return }
            let vc = VCFactory.homeScreenViewController()
            push(vc)
        }
        contentView.onCommentTapped = { [weak self] mood in
            guard let self else { return }
            let vc = VCFactory.moodPopup(mood: mood ?? .bad)
            presentScale(vc)
        }
        
        contentView.onListenTapped = { [weak self] in
            guard let self else { return }
            let vc = VCFactory.playerViewController()
            push(vc)
        }
        
        contentView.onMoodSendTapped = { [weak self]  mood in
            guard let self else { return }
            hendlingOnTapSendButton(mood: mood, text: "")
        }
    }
    
    private func hendlingOnTapSendButton(mood: Mood, text: String?) {
        viewModel.saveCommentAndEmotional(text: text ?? "", mood: mood, )
        contentView.saveMoodAction(mood: mood)
    }
    
    //MARK: - Action
    
    private func handleMood(_ mood: Mood, text: String?) {
        hendlingOnTapSendButton(mood: mood, text: text ?? "")
    }
}
