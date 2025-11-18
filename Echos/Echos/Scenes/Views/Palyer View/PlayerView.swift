//
//  PlayerView.swift
//  Echos
//
//  Created by Emma on 14.11.25.
//

import UIKit
import Lottie

final class PlayerView: BaseView {
    
    var onPlayPauseTapped: (() -> Void)?
    var onPlaybackFinished: (() -> Void)?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "player_background_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: "Спокойствие и\nумиротворение",
                font: EchosFont.unboundedBold(size: 32).uiFont,
                textColor: .echosBlack80,
                textAlignment: .left
            ),
            echosLabelHighlightConfig: .init(
                title: "умиротворение",
                font: EchosFont.unboundedBold(size: 35).uiFont,
                textColor: .echosBlack,
                textAlignment: .left
            )
        )
        return label
    }()
    
    private lazy var playAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "voise_paly_button")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var playAndPousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play_icon"), for: .normal)
        button.setImage(UIImage(named: "pous_icon"), for: .selected)
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 16).uiFont
        label.textColor = .echosBlack80
        label.textAlignment = .center
        label.text = "02:31"
        return label
    }()
    
    private lazy var bottomAnimationView:  LottieAnimationView = {
        let view = LottieAnimationView(name: "voice_line")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var isPlaying: Bool = false
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        setupView()
    }
    
    private func setupView() {
        addSubviews(backgroundImageView)
        addSubviews(titleLabel)
        addSubviews(playAnimationView)
        addSubviews(playAndPousButton)
        addSubviews(timeLabel)
        addSubviews(bottomAnimationView)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalToSuperview().inset(19)
        }
        playAnimationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        playAndPousButton.snp.makeConstraints {
            $0.center.equalTo(playAnimationView)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(playAnimationView.snp.bottom)
            $0.centerX.equalTo(playAnimationView)
        }
        bottomAnimationView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    @objc private func playPauseButtonTapped() {
        onPlayPauseTapped?()
    }
    
    func setIsPlaying(_ playing: Bool) {
        guard playing != isPlaying else { return }
        
        isPlaying = playing
        playAndPousButton.isSelected = playing
        
        if playing {
            playAnimationView.play()
            bottomAnimationView.play()
        } else {
            playAnimationView.pause()
            bottomAnimationView.pause()
        }
    }
    
    func setTime(_ text: String) {
        timeLabel.text = text
    }
}
