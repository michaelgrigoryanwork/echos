//
//  OnboardingStepsItemView.swift
//  Echos
//
//  Created by Michael Grigoryan on 02.09.25.
//

import UIKit

final class OnboardingStepsItemView: BaseView {
    // MARK: - Views
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: EchosLabel = {
        let label = EchosLabel()
        return label
    }()
    
    private lazy var subtitleLabel: EchosLabel = {
        let label = EchosLabel()
        return label
    }()

    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        addSubviews(logoImageView, titleLabel, subtitleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoImageView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(titleLabel.snp.top).inset(-32.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(subtitleLabel.snp.top).inset(-10.0)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(82.0)
        }
    }
    
    func setupData(item: OnboardingStep?) {
        logoImageView.image = item?.image
        titleLabel.update(
            echosLabelConfig: .init(
                title: item?.title,
                font: EchosFont.unboundedBold(size: 24).uiFont,
                textColor: .echosBlack80
            ),
            echosLabelHighlightConfig: .init(
                title: item?.titleHighlight,
                font: EchosFont.unboundedBold(size: 22).uiFont,
                textColor: .echosViolet
            )
        )
        subtitleLabel.update(
            echosLabelConfig: .init(
                title: item?.subtitle,
                font: EchosFont.helveticaRegular(size: 16).uiFont,
                textColor: .echosBlack80
            )
        )
    }
}
