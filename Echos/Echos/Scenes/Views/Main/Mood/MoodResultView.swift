//
//  MoodResultView.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import UIKit
import SnapKit

final class MoodResultView: BaseView {
    
    // MARK: - Callbacks
    var onChangeTapped: (() -> Void)?
    
    // MARK: - UI
    
    private let moodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(54)
        }
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "emotional.mood.result.prefix".localized()
        label.textColor = .black50
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaMedium(size: 20).uiFont
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("emotional.mood.change".localized(), for: .normal)
        button.setTitleColor(.echosBlack, for: .normal)
        button.titleLabel?.font = EchosFont.helveticaRegular(size: 16).uiFont
        let image = UIImage(named: "plus_icon")
        button.setImage(image, for: .normal)
        button.tintColor = .echosBlack
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.echosBlack.withAlphaComponent(0.15).cgColor
        button.addTarget(self, action: #selector(handleChangeTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init / Setup
    
    override func setupViews() {
        super.setupViews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .calendarBackground
        layer.cornerRadius = 24
        clipsToBounds = true
        
        // Верхняя часть: иконка + текст
        let labelsStack = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 2
        labelsStack.alignment = .leading
        
        let topStack = UIStackView(arrangedSubviews: [moodImageView, labelsStack])
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.spacing = 16
        
        // Главный вертикальный стек
        let contentStack = UIStackView(arrangedSubviews: [topStack, changeButton])
        contentStack.axis = .vertical
        contentStack.spacing = 16
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
        
        changeButton.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
    }
    
    // MARK: - Public
    
    func configure(with mood: Mood) {
        moodImageView.image = UIImage(named: mood.iconName)
        titleLabel.text = mood.titleKey.localized()
    }
    
    // MARK: - Actions
    
    @objc private func handleChangeTapped() {
        onChangeTapped?()
    }
}
