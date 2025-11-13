//
//  PaywallPlansContanieView.swift
//  Echos
//
//  Created by Emma on 13.11.25.
//

import UIKit

final class PaywallPlansContanieView: BaseView {

    var tryFreeTrigger: (() -> Void)?
    var termsAndConditionsTrigger: (() -> Void)?
    var restorPurchasesTrigger: (() -> Void)?
    var privacyPolicyTrigger: (() -> Void)?
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    private var verticalItem1 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.personalStatistics".localized()
    )
    private var verticalItem2 = FeatureCheckRow(
        text: "OnboardingPlansPaywall.feature.shortMeditations".localized()
    )
    private var verticalItem3 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.unlimitedEntriesV2".localized()
    )
    private var verticalItem4 = FeatureCheckRow(
        text: "OnboardingPaywall.feature.gentlePhrasesSupport".localized()
    )
    
    private lazy var centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private var monthlyItem = PriceContanieView(
        titleText: "OnboardingPaywall.plan.monthly".localized(), mainPrise: "$9,99/month", secondPrice: "$2,49/week"
    )
    
    private var annualItem = PriceContanieView(
        titleText: "OnboardingPaywall.plan.annual".localized(), mainPrise: "$49,99/yearly", secondPrice: "$1,04/week"
    )
    
    private var lifetimeItem = PriceContanieView(
        titleText: "OnboardingPaywall.plan.lifetime".localized(), mainPrise: "$69,99/yearly", secondPrice: ""
    )
    
    private lazy var noPressureLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        label.textColor = .echosBlack80
        label.numberOfLines = 0
        label.text = "OnboardingPaywall.noPressure".localized()
        label.textAlignment = .center
        return label
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
    
    
    private var discount80 = DiscountView(titleText: "80% OFF")
    private var discount100 = DiscountView(titleText: "100% profit")
    
    private func deg2rad(_ deg: CGFloat) -> CGFloat {
        deg * .pi / 180
    }
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        addSubviews(topStackView)
        addSubviews(centerStackView)
        addSubviews(noPressureLabel)
        addSubviews(tryFreeButton)
        addSubviews(footerStack)
        centerStackView.addArrangedSubview(monthlyItem)
        centerStackView.addArrangedSubview(annualItem)
        centerStackView.addArrangedSubview(lifetimeItem)
        topStackView.addArrangedSubview(verticalItem1)
        topStackView.addArrangedSubview(verticalItem2)
        topStackView.addArrangedSubview(verticalItem3)
        topStackView.addArrangedSubview(verticalItem4)
        footerStack.addArrangedSubview(termsBtn)
        footerStack.addArrangedSubview(restoreBtn)
        footerStack.addArrangedSubview(privacyBtn)
        addSubviews(discount80)
        addSubviews(discount100)
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(44)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        configureFooterButton(termsBtn, title: "OnboardingPaywall.footer.terms".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        configureFooterButton(restoreBtn, title: "OnboardingPaywall.footer.restore".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        configureFooterButton(privacyBtn, title: "OnboardingPaywall.footer.privacy".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        
        centerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(noPressureLabel.snp.top).inset(-24)
        }
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
        
        noPressureLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(tryFreeButton.snp.top).offset(-32)
        }
        
        discount80.snp.makeConstraints {
            $0.trailing.equalTo(annualItem).inset(8)
            $0.top.equalTo(annualItem).offset(-8)
        }
        
        discount100.snp.makeConstraints {
            $0.trailing.equalTo(lifetimeItem).inset(8)
            $0.top.equalTo(lifetimeItem).offset(-8)
        }
        
        discount80.transform = CGAffineTransform(rotationAngle: deg2rad(3.84))
        discount100.transform = CGAffineTransform(rotationAngle: deg2rad(-2.81))
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

final class PriceContanieView: BaseView {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let gradientLayer = CAGradientLayer()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.unboundedBold(size: 16).uiFont
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var mainPriceLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.unboundedBold(size: 16).uiFont
        label.textColor = .echosViolet
        label.textAlignment = .left
        return label
    }()
    
    private lazy var secondPriceLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.unboundedMedium(size: 12).uiFont
        label.textColor = .black50
        label.textAlignment = .left
        return label
    }()
    
    init(titleText: String, mainPrise: String, secondPrice: String) {
        super.init()
        titleLabel.text = titleText
        mainPriceLabel.text = mainPrise
        secondPriceLabel.text = secondPrice
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.masksToBounds = false
        addSubviews(blurView)
        addSubviews(titleLabel)
        addSubviews(stackView)
        stackView.addArrangedSubview(mainPriceLabel)
        stackView.addArrangedSubview(secondPriceLabel)
        
        layer.shadowColor = UIColor(
            red: 0xE8/255.0,
            green: 0xE2/255.0,
            blue: 0xC9/255.0,
            alpha: 1.0
        ).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 19, height: 23)
        layer.shadowRadius = 32
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 32
        blurView.layer.borderWidth = 0.5
        blurView.layer.borderColor = UIColor.echosBlack30.cgColor
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(85)
        }
        
        gradientLayer.colors = [
            UIColor(hex: 0xBBB6F1).cgColor,
            UIColor(hex: 0xF1B6CF).cgColor,
            UIColor(hex: 0xFFFFFF, alpha: 0.33).cgColor,   // 33%
            UIColor(hex: 0xF1C6B6).cgColor,
            UIColor(hex: 0xF1E8B6).cgColor,
            UIColor(hex: 0xFBF2D1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 1)
        blurView.layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = blurView.bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}

final class DiscountView: BaseView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.unboundedBold(size: 14).uiFont
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    init(titleText: String) {
        super.init()
        titleLabel.text = titleText
        backgroundColor = UIColor.echoGreen
        addSubviews(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8) & 0xFF) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
