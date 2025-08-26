//
//  EchosLabel.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class EchosLabel: UILabel {
    // MARK: - Properties
    private let echosLabelConfig: EchosLabelConfig
    private let echosLabelHighlightConfig: EchosLabelConfig?
    
    // MARK: - Init
    init(
        echosLabelConfig: EchosLabelConfig,
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
}

// MARK: - Setup
private extension EchosLabel {
    func setupUI() {
        setupViews()
    }
    
    func setupViews() {
        numberOfLines = echosLabelConfig.numberOfLines
    }

    func setupData() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = echosLabelConfig.textAlignment
        let attributedText = NSMutableAttributedString(
            string: echosLabelConfig.title,
            attributes: [
                .font: echosLabelConfig.font,
                .foregroundColor: echosLabelConfig.textColor,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        if let echosLabelHighlightConfig {
            let range = (echosLabelConfig.title as NSString).range(of: echosLabelHighlightConfig.title)
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
        let title: String
        let font: UIFont
        let textColor: UIColor
        let textAlignment: NSTextAlignment
        let numberOfLines: Int
        
        // MARK: - Init
        init(
            title: String = "",
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
