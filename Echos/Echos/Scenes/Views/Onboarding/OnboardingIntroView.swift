//
//  OnboardingIntroView.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class OnboardingIntroView: BaseView {
    // MARK: - Views
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(
            image: EchosImage.OnboardingIntro.logo
        )
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchoesString.OnboardingIntro.title,
                font: EchosFont.unboundedBold(size: 24).uiFont,
                textColor: .echosBlack80
            ),
            echosLabelHighlightConfig: .init(
                title: EchoesString.OnboardingIntro.titleHighlight,
                font: EchosFont.unboundedBold(size: 22).uiFont,
                textColor: .echosViolet
            )
        )
        return label
    }()
    
    private lazy var subtitleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchoesString.OnboardingIntro.subtitle,
                font: EchosFont.helveticaRegular(size: 16).uiFont,
                textColor: .echosBlack80
            )
        )
        return label
    }()
    
    private lazy var actionButton: EchosButton = {
        let button = EchosButton(
            echosButtonState: .normal(
                title: EchoesString.OnboardingIntro.buttonTitle,
            )
        )
        return button
    }()
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        addSubviews(logoImageView, titleLabel, subtitleLabel, actionButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoImageView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(titleLabel.snp.top).inset(-48.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(subtitleLabel.snp.top).inset(-10.0)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(actionButton.snp.top).inset(-90.0)
        }
        
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8.0)
        }
    }
}

// MARK: - Actions
extension OnboardingIntroView {
    func onActionButtonTap(_ closure: @escaping () -> Void) {
        actionButton.onTap(closure)
    }
}
