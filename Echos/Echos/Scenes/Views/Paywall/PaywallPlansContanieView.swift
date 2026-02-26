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
        titleText: "OnboardingPaywall.plan.lifetime".localized(), mainPrise: "$69,99", secondPrice: ""
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
    
    private lazy var topStackViewContanierView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    private var discount80 = DiscountView(titleText: "80% OFF")
    private var discount100 = DiscountView(titleText: "100% profit")
    
    private func deg2rad(_ deg: CGFloat) -> CGFloat {
        deg * .pi / 180
    }
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        addSubviews(topStackViewContanierView, centerStackView, noPressureLabel, tryFreeButton, footerStack)
        topStackViewContanierView.addSubview(topStackView)
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
        
        topStackViewContanierView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(centerStackView.snp.top)
        }
        
        topStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
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
