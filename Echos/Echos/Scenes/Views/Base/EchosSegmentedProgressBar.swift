//
//  EchosSegmentedProgressBar.swift
//  Echos
//
//  Created by Michael Grigoryan on 29.08.25.
//

import UIKit
import SnapKit

final class EchosSegmentedProgressBar: UIView {
    // MARK: - Views
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    private var segments: [UIView] = []
    
    // MARK: - Properties
    private let echosSegmentedProgressBarConfig: EchosSegmentedProgressBarConfig
    private var currentIndex: Int = 0
    
    // MARK: - Init
    init(
        echosSegmentedProgressBarConfig: EchosSegmentedProgressBarConfig
    ) {
        self.echosSegmentedProgressBarConfig = echosSegmentedProgressBarConfig
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.echosSegmentedProgressBarConfig = .defaultConfig
        super.init(frame: .zero)
        setupUI()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        segments.forEach { segment in
            segment.layer.cornerRadius = bounds.height / 2
        }
    }

    // MARK: - Setup
    func setupData(totalSegmentsCount: Int) {
        for _ in 0..<totalSegmentsCount {
            let segment = UIView()
            segment.backgroundColor = echosSegmentedProgressBarConfig.normalColor
            segments.append(segment)
            stackView.addArrangedSubview(segment)
        }
    }
}

// MARK: - Actions
extension EchosSegmentedProgressBar {
    func highlightSegment(at index: Int) {
        guard index < segments.count else { return }
        for (i, segment) in segments.enumerated() {
            if i <= index {
                segment.backgroundColor = echosSegmentedProgressBarConfig.selectedColor
            } else {
                segment.backgroundColor = echosSegmentedProgressBarConfig.normalColor
            }
        }
        currentIndex = index
    }
}

// MARK: - Setup
private extension EchosSegmentedProgressBar {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Config
extension EchosSegmentedProgressBar {
    struct EchosSegmentedProgressBarConfig {
        // MARK: - Properties
        let selectedColor: UIColor
        let normalColor: UIColor

        // MARK: - Init
        init(
            selectedColor: UIColor,
            normalColor: UIColor
        ) {
            self.selectedColor = selectedColor
            self.normalColor = normalColor
        }
        
        // MARK: - Default
        static var defaultConfig: EchosSegmentedProgressBarConfig {
            return .init(
                selectedColor: .echosBlack80,
                normalColor: .echosBlack15
            )
        }
    }
}
