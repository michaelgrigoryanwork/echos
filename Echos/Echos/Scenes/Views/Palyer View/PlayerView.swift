//
//  PlayerView.swift
//  Echos
//
//  Created by Emma on 14.11.25.
//

import UIKit
import Lottie

enum PlayerBackgroundColor: CaseIterable {
    case cream
    case lavender
    case mint
    case peach
    case pink
    case sky
    
    var normalImage: UIImage? {
        UIImage(named: "player_background_\(rawValue)")
    }
    
    var selectedImage: UIImage? {
        UIImage(named: "player_background_\(rawValue)_selected")
    }
}

private extension PlayerBackgroundColor {
    var rawValue: String {
        switch self {
        case .cream: return "cream"
        case .lavender: return "lavender"
        case .mint: return "mint"
        case .peach: return "peach"
        case .pink: return "pink"
        case .sky: return "sky"
        }
    }
}

final class PlayerView: BaseView {
    
    var onPlayPauseTapped: (() -> Void)?
    var onPlaybackFinished: (() -> Void)?
    private var currentBackground: PlayerBackgroundColor?
    private var didSetInitialBackground = false
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
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
        let view = LottieAnimationView()
        return view
    }()
    
    private lazy var playAndPousAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        return view
    }()
    
    
    private lazy var playAndPousButton: UIButton = {
        let button = UIButton()
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
        let view = LottieAnimationView(name: "wavestop")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var isPlaying: Bool = false
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        setupView()
        configureForNewTrack()
    }
    
    private func setupView() {
        addSubviews(backgroundImageView)
        addSubviews(titleLabel)
        addSubviews(playAnimationView)
        addSubviews(playAndPousAnimationView)
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
        playAndPousAnimationView.snp.makeConstraints {
            $0.center.equalTo(playAnimationView)
        }
        playAndPousButton.snp.makeConstraints {
            $0.center.equalTo(playAnimationView)
            $0.size.equalTo(playAnimationView)
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
        
        DispatchQueue.main.async {
            self.playAndPousLogik(isPlaying: self.isPlaying)
        }
    }
    
    func configureForTrack(id: String) {
        let index = abs(id.hashValue) % PlayerBackgroundColor.allCases.count
        currentBackground = PlayerBackgroundColor.allCases[index]
        updateBackground(isPlaying: isPlaying)
    }
    
    func configureForNewTrack() {
        let randomColor = PlayerBackgroundColor.allCases.randomElement()
        currentBackground = randomColor
        updateBackground(isPlaying: isPlaying)
    }
    
    private func setBackgroundImageAnimated(_ image: UIImage?) {
        UIView.transition(
            with: backgroundImageView,
            duration: 0.35,
            options: [.transitionCrossDissolve, .allowUserInteraction],
            animations: {
                self.backgroundImageView.image = image
            },
            completion: nil
        )
    }
    
    private func updateBackground(isPlaying: Bool) {
        guard let bg = currentBackground else { return }
        let image = isPlaying ? bg.selectedImage : bg.normalImage
        
        if didSetInitialBackground {
            setBackgroundImageAnimated(image)
        } else {
            backgroundImageView.image = image
            didSetInitialBackground = true
        }
    }
    
    @objc private func playPauseButtonTapped() {
        onPlayPauseTapped?()
    }
    
    func setIsPlaying(_ playing: Bool) {
        guard playing != isPlaying else { return }
        
        isPlaying = playing
        playAndPousButton.isSelected = playing
        
        playAndPousLogik(isPlaying: playing)
    }
    
    func setTime(_ text: String) {
        timeLabel.text = text
    }
    
    private func playAndPousLogik(isPlaying: Bool) {
        updateBackground(isPlaying: isPlaying)
        if isPlaying {
            playAnimationView.animation = LottieAnimation.named("player_play")

            playAnimationView.loopMode = .loop
            playAnimationView.contentMode = .scaleAspectFit
            playAnimationView.animationSpeed = 2
            playAnimationView.play()
            
            playAndPousAnimationView.animation = LottieAnimation.named("play_pause")

            playAndPousAnimationView.loopMode = .loop
            playAndPousAnimationView.contentMode = .scaleAspectFit
            playAndPousAnimationView.animationSpeed = 0.3
            playAndPousAnimationView.play()
            
            bottomAnimationView.play()
        } else {
            playAnimationView.animation = LottieAnimation.named("player_waiting")

            playAnimationView.loopMode = .loop
            playAnimationView.contentMode = .scaleAspectFit
            playAnimationView.animationSpeed = 2
            playAnimationView.play()
            
            playAndPousAnimationView.animation = LottieAnimation.named("pause_play")
            playAndPousAnimationView.loopMode = .loop
            playAndPousAnimationView.contentMode = .scaleAspectFit
            playAndPousAnimationView.animationSpeed = 0.3
            playAndPousAnimationView.play()
            
            bottomAnimationView.pause()
        }
    }
}
