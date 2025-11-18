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
    private let audioService = MeditationAudioService()
    
    // MARK: - Init
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = PlayerViewModel(
            audioService: audioService,
            initialTrack: .calmness 
        )
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
        
        setNavigationTitle(
            "meditation.title".localized(),
            font: EchosFont.helveticaMedium(size: 18).uiFont,
            color: .echosBlack
        )
        setupClosures()
    }
    
    private func setupClosures() {
        contentView.onPlayPauseTapped = { [weak self] in
            self?.viewModel.togglePlayPause()
        }
        
        viewModel.onIsPlayingChanged = { [weak self] isPlaying in
            self?.contentView.setIsPlaying(isPlaying)
        }
        
        viewModel.onTimeChanged = { [weak self] time in
            self?.contentView.setTime(time)
        }
        
        viewModel.viewDidLoad()
    }
}
