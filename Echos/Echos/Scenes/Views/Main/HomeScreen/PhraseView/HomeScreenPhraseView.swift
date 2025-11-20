//
//  HomeScreenPhraseView.swift
//  Echos
//
//  Created by Emma on 19.11.25.
//

import UIKit

final class HomeScreenPhraseView: BaseView {
    
    enum MessengerType {
        case appMessenger
        case vk
        case telegram
        case whatsapp
        
        var iconName: String {
            switch self {
            case .appMessenger: return "vk_button_icon"
            case .vk:           return "vk_button_icon"
            case .telegram:     return "vk_button_icon"
            case .whatsapp:     return "vk_button_icon"
            }
        }
    }
    
    var onMessengerTap: ((MessengerType) -> Void)?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "phrase_of_the_day_background")
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "phrase_of_the_day_logo")
        return imageView
    }()
    
    private let phraseLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: "Побеждают\nне идеальные\nа упорные.\nБудь\nупорным!",
                font: EchosFont.unboundedSemiBold(size: 28).uiFont,
                textColor: .echosBlack80,
                textAlignment: .left
            ),
            echosLabelHighlightConfig: .init(
                title: "Будь\nупорным!",
                font: EchosFont.unboundedSemiBold(size: 28).uiFont,
                textColor: .echosBlack,
                textAlignment: .left
            )
        )
        return label
    }()
    
    private lazy var messengerLabel: UILabel = {
        let label = UILabel()
        label.text = "home.share_with_friends".localized()
        label.font = EchosFont.helveticaMedium(size: 18).uiFont
        label.textColor = .echosBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var messengerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .calendarBackground
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var messengerButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var messengerTypes: [MessengerType] = []
    
    
    override func setupViews() {
        super.setupViews()
        
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        addSubviews(scrollView)
        
        scrollView.addSubviews(imageView)
        scrollView.addSubviews(phraseLabel)
        scrollView.addSubviews(logoImageView)
        scrollView.addSubviews(messengerBackgroundView)
        messengerBackgroundView.addSubviews(messengerLabel)
        messengerBackgroundView.addSubviews(messengerButtonStackView)
        
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        phraseLabel.snp.makeConstraints {
            $0.top.equalTo(imageView).offset(18)
            $0.leading.trailing.equalTo(imageView).inset(24)
        }
        logoImageView.snp.makeConstraints {
            $0.leading.equalTo(imageView).offset(24)
            $0.bottom.equalTo(imageView).inset(24)
            $0.size.equalTo(48)
        }
        messengerBackgroundView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        messengerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        messengerButtonStackView.snp.makeConstraints {
            $0.top.equalTo(messengerLabel.snp.bottom).offset(16)
            $0.trailing.leading.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(68)
        }
    }
    
    func configure(messengers: [MessengerType]) {
        messengerButtonStackView.arrangedSubviews.forEach {
            messengerButtonStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        messengerTypes = messengers
        
        for (index, type) in messengers.enumerated() {
            let button = UIButton()
            button.tag = index
            button.setImage(UIImage(named: type.iconName), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(messengerButtonTapped(_:)), for: .touchUpInside)
            messengerButtonStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func messengerButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0, index < messengerTypes.count else { return }
        let type = messengerTypes[index]
        onMessengerTap?(type)
    }
}
