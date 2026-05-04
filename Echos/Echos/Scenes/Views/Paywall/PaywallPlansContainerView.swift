//
//  PaywallPlansContainerView.swift
//  Echos
//
//  Created by Emma on 13.11.25.
//

import UIKit
import ApphudSDK

final class PaywallPlansContainerView: BaseView {

    var actionButtonTrigger: (() -> Void)?
    
    var productSelectTrigger: ((ApphudProduct?) -> Void)?
    
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
    
    private lazy var productsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var noPressureLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        label.textColor = .echosBlack80
        label.numberOfLines = 0
        label.text = "OnboardingPaywall.noPressure".localized()
        label.textAlignment = .center
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = EchosFont.helveticaMedium(size: 16).uiFont
        button.backgroundColor = .echosBlack
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(actionButtonAction), for: .touchUpInside)
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
    func setData(paywallModel: PaywallModelProtocol, selectedProduct: ApphudProduct?) {
        guard let products = paywallModel.products else {
            return
        }
        
        productsStackView.arrangedSubviews.forEach { arrangedSubview in
            arrangedSubview.removeFromSuperview()
        }
        
        products.forEach { product in
            let view = PriceContainerView(
                product: product,
                isSelected: product.productId == selectedProduct?.productId
            )
            view.productSelectTrigger = productSelectTrigger
            productsStackView.addArrangedSubview(view)
        }
        
        if let product = selectedProduct?.skProduct {
            Task {
                let isIntroAvailable = await PaywallModel.isIntroAvailable(product: product)
                actionButton.setTitle(isIntroAvailable ? "OnboardingPaywall.cta.tryFree".localized() : "Paywall.subscribe".localized(), for: .normal)
            }
        } else {
            actionButton.setTitle("OnboardingPaywall.cta.tryFree".localized(), for: .normal)
        }
    }
    
    func selectProduct(product: ApphudProduct) {
        productsStackView.arrangedSubviews.forEach { view in
            guard let priceView = view as? PriceContainerView else { return }
            priceView.isSelected = priceView.product?.productId == product.productId
        }
        
        if let product = product.skProduct {
            Task {
                let isIntroAvailable = await PaywallModel.isIntroAvailable(product: product)
                actionButton.setTitle(isIntroAvailable ? "OnboardingPaywall.cta.tryFree".localized() : "Paywall.subscribe".localized(), for: .normal)
            }
        } else {
            actionButton.setTitle("OnboardingPaywall.cta.tryFree".localized(), for: .normal)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubviews(topStackViewContanierView, productsStackView, noPressureLabel, actionButton, footerStack)
        topStackViewContanierView.addSubview(topStackView)
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
            $0.bottom.equalTo(productsStackView.snp.top)
        }
        
        topStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        configureFooterButton(termsBtn, title: "OnboardingPaywall.footer.terms".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        configureFooterButton(restoreBtn, title: "OnboardingPaywall.footer.restore".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        configureFooterButton(privacyBtn, title: "OnboardingPaywall.footer.privacy".localized(), font: EchosFont.helveticaRegular(size: 12).uiFont)
        
        productsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(noPressureLabel.snp.top).inset(-24)
        }
        footerStack.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
            $0.bottom.equalTo(footerStack.snp.top).offset(-16)
        }
        
        noPressureLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(actionButton.snp.top).offset(-32)
        }

        setupDummyProducts()
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
    
    
    @objc private func actionButtonAction() {
        actionButtonTrigger?()
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

private extension PaywallPlansContainerView {
    func setupDummyProducts() {
        for _ in 0...2 {
            let view = PriceContainerView(
                product: nil,
                isSelected: false
            )
            productsStackView.addArrangedSubview(view)
        }
    }
}
