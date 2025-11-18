//
//  MeditationView.swift
//  Echos
//
//  Created by Emma on 18.11.25.
//

import UIKit
import SnapKit

final class MeditationView: BaseView {
    
    // MARK: - Callbacks
    var onListenTapped: (() -> Void)?
    
    // MARK: - UI
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "meditation_icon")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "meditation.title".localized()
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaMedium(size: 24).uiFont
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "meditation.description".localized()
        label.textColor = .echosBlack80
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var listenButton: UIButton = {
        let button = UIButton()
        button.setTitle("meditation.listen".localized(), for: .normal)
        button.setTitleColor(.echosBlack80, for: .normal)
        button.titleLabel?.font = EchosFont.helveticaRegular(size: 16).uiFont
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.echosBlack80.cgColor
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleListenTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func setupViews() {
        super.setupViews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .meditationBackground
        layer.cornerRadius = 24
        clipsToBounds = true
        
        addSubviews(iconImageView)
        addSubviews(titleLabel)
        addSubviews(descriptionLabel)
        addSubviews(listenButton)
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-8)
            $0.trailing.equalToSuperview().inset(-8)
            $0.size.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.lessThanOrEqualTo(iconImageView.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        listenButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleListenTapped() {
        onListenTapped?()
    }
}

