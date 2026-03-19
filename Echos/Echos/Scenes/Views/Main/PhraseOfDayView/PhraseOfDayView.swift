//
//  PhraseOfDayView.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import UIKit
import SnapKit

final class PhraseOfDayView: BaseView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "emotional.phrase.title".localized()
        label.textColor = .black
        label.font = EchosFont.helveticaMedium(size: 24).uiFont
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "phrase_Of_day_icon")
        return imageView
    }()
    
    private lazy var phraseContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(50)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.echosBlack15.cgColor
        return view
    }()
    
    private let phraseLabel: EchosLabel = {
        let label = EchosLabel()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func setupViews() {
        super.setupViews()
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .phraseOfDayBackground
        layer.cornerRadius = 24
        addSubviews(titleLabel)
        addSubviews(iconImageView)
        addSubviews(phraseContainerView)
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(26)
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.top.equalToSuperview().inset(-10)
            $0.trailing.equalToSuperview().inset(-4)
        }
        phraseContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        phraseContainerView.addSubviews(phraseLabel)
        phraseLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Public API
    
    func configure(phrase: Phrase) {
        phraseLabel.update(
            echosLabelConfig: .init(
                title: phrase.message?.en,
                font: EchosFont.unboundedSemiBold(size: 24).uiFont,
                textColor: .echosBlack80,
                textAlignment: .left
            ),
            echosLabelHighlightConfig: .init(
                title: phrase.highlight?.en,
                font: EchosFont.unboundedSemiBold(size: 24).uiFont,
                textColor: .echosBlack,
                textAlignment: .left
            )
        )
    }
}

