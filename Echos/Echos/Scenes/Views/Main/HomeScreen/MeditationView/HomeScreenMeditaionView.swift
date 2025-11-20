//
//  HomeScreenMeditaionView.swift
//  Echos
//
//  Created by Emma on 19.11.25.
//

import UIKit

final class HomeScreenMeditationView: BaseView {
    
    
    enum MeditationType: Int, CaseIterable {
        case calm
        case energy
        case relax
        case deepThinking
        case searchingAnswers
        case breathing
        
        var title: String {
            switch self {
            case .calm:
                return "home.meditation.calm".localized()
            case .energy:
                return "home.meditation.energy".localized()
            case .relax:
                return "home.meditation.relax".localized()
            case .deepThinking:
                return "home.meditation.deep_thinking".localized()
            case .searchingAnswers:
                return "home.meditation.search_answers".localized()
            case .breathing:
                return "home.meditation.breathing".localized()
            }
        }
    }
    
    var onMeditationSelected: ((MeditationType) -> Void)?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mediation_view_background")
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.backgroundColor = .echosBlue
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "home.category.meditation".localized()
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaMedium(size: 24).uiFont
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "home.meditation.choose_type".localized()
        label.textColor = .echosBlack80
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rowsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    override func setupViews() {
        super.setupViews()
        setupView()
        setupRows()
    }
    
    private func setupView() {
        backgroundColor = .mainBackground
        addSubviews(backgroundImageView)
        addSubviews(scrollView)
        scrollView.addSubviews(backgroundView)
        backgroundView.addSubviews(titleLabel, descriptionLabel, rowsStackView)
        
        backgroundImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        rowsStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    private func setupRows() {
        MeditationType.allCases.enumerated().forEach { index, type in
            let button = makeRowButton(title: type.title, tag: index)
            rowsStackView.addArrangedSubview(button)
        }
    }
    
    private func makeRowButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        
        let view = UIView()
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.textColor = .echosBlack80
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        label.textAlignment = .left
        label.text = title
        label.isUserInteractionEnabled = false

        
        let arrow = UIImageView(image: UIImage(named: "arrow_right_icon"))
        arrow.isUserInteractionEnabled = false


        button.addSubviews(view)
        view.addSubviews(label, arrow)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(arrow.snp.leading).inset(4)
        }
        
        arrow.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        button.addTarget(self, action: #selector(rowTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func rowTapped(_ sender: UIButton) {
        guard sender.tag >= 0,
              sender.tag < MeditationType.allCases.count else { return }
        let type = MeditationType.allCases[sender.tag]
        onMeditationSelected?(type)
    }
}
