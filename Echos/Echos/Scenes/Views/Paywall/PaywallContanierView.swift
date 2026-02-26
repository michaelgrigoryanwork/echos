//
//  PaywallContanierView.swift
//  Echos
//
//  Created by Emma on 10.11.25.
//

import Foundation
import UIKit

final class PaywallContanierView: BaseView {
    
    var tryFreeTrigger: (() -> Void)?
    var viewOthersTrigger: (() -> Void)?
    var termsAndConditionsTrigger: (() -> Void)?
    var restorPurchasesTrigger: (() -> Void)?
    var privacyPolicyTrigger: (() -> Void)?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "paywallBackground")
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: "OnboardingPaywall.titleOne".localized(),
                font: EchosFont.unboundedBold(size: 42).uiFont,
                textColor: .echosBlack80,
                textAlignment: .left
            )
        )
        return label
    }()
    
    private lazy var subtitleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: "OnboardingPaywall.titleTwo".localized(),
                font: EchosFont.unboundedBold(size: 42).uiFont,
                textColor: .echosBlack,
                textAlignment: .right
            ),
            echosLabelHighlightConfig: .init(
                title: "OnboardingPaywall.titleTwoHighlight".localized(),
                font: EchosFont.unboundedBold(size: 42).uiFont,
                textColor: .echosViolet,
                textAlignment: .right
            )
        )
        return label
    }()
    
    private lazy var freeDaysContanierView: UIView = {
        let view = UIView()
        view.backgroundColor = .paywallContanierWhite30
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        return  view
    }()
    
    private lazy var stackViewFreeDays: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 26
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    
    private var item1 = FreeDaysContanierViewElement(
        image: UIImage(named: "record_paywall_icon") ?? UIImage(),
        title: "OnboardingPaywall.bullet1".localized()
    )
    
    private var item2 = FreeDaysContanierViewElement(
        image: UIImage(named: "we_are_paywall_icon") ?? UIImage(),
        title: "OnboardingPaywall.bullet2".localized()
    )
    
    private lazy var tryFree7DaysLabel: UILabel = {
        let label = UILabel()
        label.text = "OnboardingPaywall.ribbon.try7daysFree".localized()
        label.font = EchosFont.unboundedBold(size: 18).uiFont
        label.textColor = .black
        return label
    }()
    
    private lazy var tryfreeDaysView: UIView = {
        let view = UIView()
        view.backgroundColor = .daysFree
        view.addSubview(tryFree7DaysLabel)
        return view
    }()
    
    private func deg2rad(_ deg: CGFloat) -> CGFloat {
        deg * .pi / 180
    }
    
    private lazy var verticalFirstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    
    private lazy var verticalSecondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private var verticalItem1 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.personalStats".localized()
    )
    
    private var verticalItem2 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.shortMeditations".localized()
    )
    
    private var verticalItem3 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.unlimitedEntries".localized()
    )
    private var verticalItem4 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.gentleSupport".localized()
    )
    
    private lazy var priceLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: "Try 7 days free, then $9,99/month".localized(),
                font: EchosFont.unboundedSemiBold(size: 14).uiFont,
                textColor: .echosBlack,
            ),
            echosLabelHighlightConfig: .init(
                title: "Try 7 days free",
                font: EchosFont.unboundedSemiBold(size: 14).uiFont,
                textColor: .echosViolet,
            )
        )
        return label
    }()
    
    private lazy var noPressureLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 12).uiFont
        label.textColor = .black50
        label.numberOfLines = 0
        label.text = "OnboardingPaywall.noPressure".localized()
        label.textAlignment = .center
        return label
    }()
    
    
    private let otherPlansButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(otherPlansButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tryFreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("OnboardingPaywall.cta.tryFree".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = EchosFont.helveticaMedium(size: 16).uiFont
        button.backgroundColor = .echosBlack
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(tryFreeAction), for: .touchUpInside)
        return button
    }()
    
    private let footerStack: UIStackView = {
        let footerStack = UIStackView()
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.distribution = .equalSpacing
        footerStack.spacing = 18
        return footerStack
    }()
    
    private let termsBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(termsOfUseAction), for: .touchUpInside)
        return button
    }()
    private let restoreBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(restorePurchasesAction), for: .touchUpInside)
        return button
    }()
    private let privacyBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(privacyPolicyAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        addSubviews(scrollView, backgroundImageView, otherPlansButton, tryFreeButton, footerStack)
        scrollView.addSubviews(titleLabel, subtitleLabel, freeDaysContanierView, tryfreeDaysView, verticalFirstStackView, verticalSecondStackView, priceLabel, noPressureLabel, otherPlansButton)
        freeDaysContanierView.addSubviews(stackViewFreeDays)
        stackViewFreeDays.addArrangedSubview(item1)
        stackViewFreeDays.addArrangedSubview(item2)
        verticalFirstStackView.addArrangedSubview(verticalItem1)
        verticalFirstStackView.addArrangedSubview(verticalItem2)
        verticalSecondStackView.addArrangedSubview(verticalItem3)
        verticalSecondStackView.addArrangedSubview(verticalItem4)
        footerStack.addArrangedSubview(termsBtn)
        footerStack.addArrangedSubview(restoreBtn)
        footerStack.addArrangedSubview(privacyBtn)
        
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-300)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tryFreeButton.snp.top).inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(2)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        freeDaysContanierView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(32)
        }
        
        stackViewFreeDays.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(24)
        }
        
        tryFree7DaysLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        tryfreeDaysView.snp.makeConstraints {
            $0.top.equalTo(freeDaysContanierView.snp.top).offset(-6)
            $0.trailing.equalTo(freeDaysContanierView).inset(16)
        }
        
        tryfreeDaysView.transform = CGAffineTransform(rotationAngle: deg2rad(3.84))
        
        verticalFirstStackView.snp.makeConstraints {
            $0.top.equalTo(freeDaysContanierView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().inset(44)
        }
        
        verticalSecondStackView.snp.makeConstraints {
            $0.top.equalTo(verticalFirstStackView)
            $0.leading.equalTo(verticalFirstStackView.snp.trailing).offset(18)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(verticalSecondStackView.snp.bottom).offset(44)
        }
        
        noPressureLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(priceLabel.snp.bottom)
        }
        
        configureFooterButton(otherPlansButton, title: "OnboardingPaywall.link.viewOtherPlans".localized(), font: EchosFont.helveticaMedium(size: 14).uiFont)
        
        otherPlansButton.snp.makeConstraints {
            $0.top.equalTo(noPressureLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        configureFooterButton(termsBtn, title: "OnboardingPaywall.footer.terms".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        configureFooterButton(restoreBtn, title: "OnboardingPaywall.footer.restore".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        configureFooterButton(privacyBtn, title: "OnboardingPaywall.footer.privacy".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        
        footerStack.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
        }
        
        tryFreeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
            $0.bottom.equalTo(footerStack.snp.top).offset(-16)
        }
    }
    
    private func configureFooterButton(_ button: UIButton, title: String, font: UIFont) {
        let attribut = NSAttributedString(
            string: title,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.echosBlack80,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
        button.setAttributedTitle(attribut, for: .normal)
        button.contentHorizontalAlignment = .leading
    }
    
    //MARK: - Action
    
    @objc private func otherPlansButtonTapped() {
        viewOthersTrigger?()
    }
    
    @objc private func tryFreeAction() {
        tryFreeTrigger?()
    }
    
    @objc private func restorePurchasesAction() {
        restorPurchasesTrigger?()
    }
    
    @objc private func termsOfUseAction() {
        termsAndConditionsTrigger?()
    }
    
    @objc private func privacyPolicyAction() {
        privacyPolicyTrigger?()
    }
}

final class FreeDaysContanierViewElement: BaseView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 16).uiFont
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    init(image: UIImage, title: String) {
        super.init()
        self.imageView.image = image
        self.titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = .clear
        addSubviews(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(61)
        }
    }
}

final class FeatureCheckRow: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paywall_check_icon")
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = EchosFont.helveticaRegular(size: 16).uiFont
        label.textColor = .echosBlack80
        label.textAlignment = .left
        return label
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        build()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func build() {
        addSubviews(iconImageView, label)
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(label)
        }
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.bottom.trailing.equalToSuperview()
        }
    }
}


