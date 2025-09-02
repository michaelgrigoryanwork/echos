//
//  EchosButton.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit
import SnapKit

final class EchosButton: UIButton {
    // MARK: - Handlers
    private var didTap: (() -> Void)?

    // MARK: - Properties
    private let echosButtonState: EchosButtonState
    
    // MARK: - Init
    init(echosButtonState: EchosButtonState) {
        self.echosButtonState = echosButtonState
        super.init(frame: .zero)
        setupUI()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        self.echosButtonState = .normal(
            config: .defaultConfig
        )
        super.init(frame: .zero)
        setupUI()
        setupData()
    }
}

// MARK: - Setup
private extension EchosButton {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        setTitleColor(echosButtonState.config.titleColor, for: .normal)
        titleLabel?.font = echosButtonState.config.font
        backgroundColor = echosButtonState.config.backgroundColor
        layer.cornerRadius = echosButtonState.config.cornerRadius
    }
    
    func setupConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(54.0)
        }
    }
    
    func setupData() {
        setTitle(echosButtonState.title, for: .normal)
        isUserInteractionEnabled = echosButtonState.isUserInteractionEnabled
    }
}

// MARK: - Actions
extension EchosButton {
    func onTap(_ closure: @escaping () -> Void) {
        self.didTap = closure
        addTarget(self, action: #selector(onDidTap), for: .touchUpInside)
    }
    
    @objc private func onDidTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        didTap?()
    }
}

// MARK: - State
extension EchosButton {
    enum EchosButtonState {
        // MARK: - Cases
        case normal(
            title: String = "",
            config: EchosButtonConfig = .defaultConfig
        )
        case disabled(
            title: String = "",
            config: EchosButtonConfig = .defaultConfig
        )
        
        // MARK: - Properties
        var isUserInteractionEnabled: Bool {
            switch self {
            case .normal:
                return true
            case .disabled:
                return false
            }
        }
        
        var title: String {
            switch self {
            case .normal(let title, _):
                return title
            case .disabled(let title, _):
                return title
            }
        }
        
        var config: EchosButtonConfig {
            switch self {
            case .normal(_, let config):
                return config
            case .disabled(_, let config):
                return config
            }
        }
    }
}

// MARK: - Config
extension EchosButton {
    struct EchosButtonConfig {
        // MARK: - Properties
        let cornerRadius: CGFloat
        let font: UIFont
        let backgroundColor: UIColor
        let titleColor: UIColor
        
        // MARK: - Init
        init(
            cornerRadius: CGFloat = 16.0,
            font: UIFont,
            backgroundColor: UIColor,
            titleColor: UIColor
        ) {
            self.cornerRadius = cornerRadius
            self.font = font
            self.backgroundColor = backgroundColor
            self.titleColor = titleColor
        }
        
        // MARK: - Default
        static var defaultConfig: EchosButtonConfig {
            return .init(
                font: EchosFont.helveticaMedium(size: 16).uiFont,
                backgroundColor: .echosBlack,
                titleColor: .echosWhite
            )
        }
    }
}
