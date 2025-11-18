//
//  EmotionalView.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//
import UIKit

final class EmotionalView: BaseView {
    
    var settingsTrigger: (() -> Void)?
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settings_icon"), for: .normal)
        button.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "emotional_background_icon")
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "emotional.empty_state.title".localized()
        label.font = EchosFont.helveticaRegular(size: 12).uiFont
        label.textColor = .black50
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .emotionalBackground
        layer.cornerRadius = 24
        clipsToBounds = true
        addSubviews(settingsButton)
        addSubviews(mainImageView)
        addSubviews(descriptionLabel)
        settingsButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(30)
        }
    }
    
    //MARK: - Action
    
    @objc private func settingsAction() {
        settingsTrigger?()
    }
}
