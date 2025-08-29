//
//  EchosLabel.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class EchosLabel: UILabel {
    // MARK: - Properties
    private var echosLabelConfig: EchosLabelConfig?
    private var echosLabelHighlightConfig: EchosLabelConfig?
    
    // MARK: - Init
    init(
        echosLabelConfig: EchosLabelConfig? = nil,
        echosLabelHighlightConfig: EchosLabelConfig? = nil
    ) {
        self.echosLabelConfig = echosLabelConfig
        self.echosLabelHighlightConfig = echosLabelHighlightConfig
        super.init(frame: .zero)
        setupUI()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        self.echosLabelConfig = .init(
            font: EchosFont.helveticaRegular(size: 16).uiFont,
            textColor: .echosWhite
        )
        self.echosLabelHighlightConfig = nil
        super.init(frame: .zero)
        setupUI()
        setupData()
    }
    
    // MARK: - Setup
    func update(
        echosLabelConfig: EchosLabelConfig? = nil,
        echosLabelHighlightConfig: EchosLabelConfig? = nil
    ) {
        self.echosLabelConfig = echosLabelConfig
        self.echosLabelHighlightConfig = echosLabelHighlightConfig
        setupData()
    }
}

// MARK: - Setup
private extension EchosLabel {
    func setupUI() {
        setupViews()
    }
    
    func setupViews() {
        numberOfLines = echosLabelConfig?.numberOfLines ?? 0
    }

    func setupData() {
        guard let echosLabelConfig else {
            self.attributedText = nil
            return
        }
        let title = echosLabelConfig.title ?? ""
        let highlightTitle = echosLabelHighlightConfig?.title ?? ""
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = echosLabelConfig.textAlignment
        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: echosLabelConfig.font,
                .foregroundColor: echosLabelConfig.textColor,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        if let echosLabelHighlightConfig {
            let range = (title as NSString).range(of: highlightTitle)
            attributedText.addAttributes(
                [
                    .font: echosLabelHighlightConfig.font,
                    .foregroundColor: echosLabelHighlightConfig.textColor
                ],
                range: range
            )
        }
        
        self.attributedText = attributedText
    }
}

// MARK: - Config
extension EchosLabel {
    struct EchosLabelConfig {
        // MARK: - Properties
        let title: String?
        let font: UIFont
        let textColor: UIColor
        let textAlignment: NSTextAlignment
        let numberOfLines: Int
        
        // MARK: - Init
        init(
            title: String? = nil,
            font: UIFont,
            textColor: UIColor,
            textAlignment: NSTextAlignment = .center,
            numberOfLines: Int = 0
        ) {
            self.title = title
            self.font = font
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.numberOfLines = numberOfLines
        }
    }
}
