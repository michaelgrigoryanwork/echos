//
//  EmotionalView.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//
import UIKit
import Lottie

final class EmotionalView: BaseView {
    
    var onBubbleTap: ((MoodModel, Int) -> Void)?
    
    private lazy var animationLottiView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "no_mood_animation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 4
        return animationView
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
    
    private lazy var contanierStack: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var backgroundTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    
    private let moodClusterView = MoodClusterView()
    private let glassView = GlassView()
    private var openedBubbleIndex: Int?
    
    override func setupViews() {
        super.setupViews()
        setupView()
        setupClosure()
        addGestureRecognizer(backgroundTapRecognizer)
    }
    
    private func setupView() {
        backgroundColor = .emotionalBackground
        layer.cornerRadius = 24
        clipsToBounds = true
        addSubviews(animationLottiView, descriptionLabel, contanierStack, moodClusterView, glassView)
        
        animationLottiView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        moodClusterView.snp.makeConstraints {
            $0.center.equalTo(animationLottiView)
            $0.size.equalTo(animationLottiView)
        }
        animationLottiView.layoutIfNeeded()
        
        glassView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(24)
            $0.top.equalToSuperview().inset(animationLottiView.frame.height/2 + 74)
        }
        glassView.isHidden = true
        animationLottiView.play()
    }
    
    //MARK: - Action
    
    func setupEmotionalView(isData: Bool, text: String, model: [MoodModel]) {
        if isData {
            contanierStack.snp.removeConstraints()
            descriptionLabel.snp.removeConstraints()
            clearStackView(contanierStack)
            descriptionLabel.isHidden = true
            contanierStack.isHidden = false
            moodClusterView.isHidden = false
            contanierStack.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(animationLottiView.snp.bottom).offset(16)
                $0.bottom.equalToSuperview().inset(30)
            }
            contanierStack.addArrangedSubviews(setupViewLabel(text: "Отлично!", font: EchosFont.helveticaMedium(size: 16).uiFont, textColor: .emotionalGoodGreenLight, viewBackgroundColor: .white.withAlphaComponent(0.5)))
            contanierStack.addArrangedSubviews(setupViewLabel(text: text, font: EchosFont.helveticaRegular(size: 14).uiFont, textColor: .echosBlack80, viewBackgroundColor: .clear))
            contanierStack.addArrangedSubviews(setupViewLabel(text: "Статистика", font: EchosFont.helveticaRegular(size: 14).uiFont, textColor: .echosBlack80, viewBackgroundColor: .white))
            moodClusterView.configure(with: model)
            animationLottiView.isHidden = model.count != 0
            self.openedBubbleIndex = nil
            self.hideGlassView()
        } else {
            animationLottiView.isHidden = model.count != 0
            contanierStack.snp.removeConstraints()
            descriptionLabel.snp.removeConstraints()
            descriptionLabel.isHidden = false
            contanierStack.isHidden = true
            moodClusterView.isHidden = true
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(animationLottiView.snp.bottom).offset(16)
                $0.leading.trailing.bottom.equalToSuperview().inset(30)
            }
        }
    }
    
    private func setupViewLabel(text: String, font: UIFont, textColor: UIColor, viewBackgroundColor: UIColor) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.textColor = textColor
        label.font = font
        let view = UIView()
        view.backgroundColor = viewBackgroundColor
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        view.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        view.layer.cornerRadius = 14
        return view
    }
    
    func clearStackView(_ stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    func setupClosure() {
        moodClusterView.onBubbleTap = { [weak self] mood, index in
            guard let self else { return }
            onBubbleTap?(mood, index)
            if self.openedBubbleIndex == index {
                self.openedBubbleIndex = nil
                self.hideGlassView()
            } else {
                self.openedBubbleIndex = index
                self.glassView.setData(
                    text: mood.text ?? ""
                )
                self.showGlassView()
            }
        }
        moodClusterView.onTapRecognizer = { [weak self]  recognizer in
            guard let self else { return }
            guard self.openedBubbleIndex != nil else { return }
            self.openedBubbleIndex = nil
            self.hideGlassView()
        }
    }
    
    @objc private func handleBackgroundTap(_ recognizer: UITapGestureRecognizer) {
        guard openedBubbleIndex != nil else { return }
        let point = recognizer.location(in: self)
        if let hitView = hitTest(point, with: nil) {
            if hitView === glassView || hitView.isDescendant(of: glassView) { return }
            if hitView.isDescendant(of: moodClusterView) { return }
        }
        openedBubbleIndex = nil
        hideGlassView()
    }
    
    private func showGlassView() {
        glassView.isHidden = false
        glassView.alpha = 0
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            self.glassView.alpha = 1
        })
    }
    
    private func hideGlassView() {
        guard !glassView.isHidden else { return }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            self.glassView.alpha = 0
        }, completion: { _ in
            self.glassView.isHidden = true
        })
    }
}
