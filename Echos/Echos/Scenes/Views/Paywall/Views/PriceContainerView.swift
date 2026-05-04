//
//  PriceContainerView.swift
//  Echos
//
//  Created by Emma on 26.02.26.
//

import UIKit
import ApphudSDK
import StoreKit

final class PriceContainerView: BaseView {
    var productSelectTrigger: ((ApphudProduct?) -> Void)?

    var isSelected: Bool = false {
        didSet {
            blurView.layer.borderWidth = !isSelected ? 0.5 : 2.0
            blurView.layer.borderColor = !isSelected ? UIColor.echosBlack30.cgColor : UIColor.echosViolet.cgColor
        }
    }
    
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .echosViolet
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    
    private lazy var discount80: DiscountView = {
        let view = DiscountView(titleText: "80% OFF")
        view.isHidden = true
        view.transform = CGAffineTransform(rotationAngle: deg2rad(3.84))
        return view
    }()
    
    private lazy var discount100: DiscountView = {
        let view = DiscountView(titleText: "100% profit")
        view.isHidden = true
        view.transform = CGAffineTransform(rotationAngle: deg2rad(-2.81))
        return view
    }()
        
    private(set) var product: ApphudProduct?

    init(product: ApphudProduct?, isSelected: Bool) {
        self.product = product
        super.init()
        setupView()
        Task {
            if let storeProduct = try await product?.product() {
                setData(product: storeProduct)
                self.isSelected = isSelected
            }
        }
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
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubviews(discount80)
        discount80.snp.remakeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.top.equalToSuperview().offset(-8)
        }

        addSubviews(discount100)
        discount100.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.top.equalToSuperview().offset(-8)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = blurView.bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}

private extension PriceContainerView {
    func setData(product: Product?) {
        guard let product else {
            return
        }
        activityIndicator.stopAnimating()
        titleLabel.text = PaywallModel.getSubscriptionDisplayName(product: product)
        mainPriceLabel.text = PaywallModel.getSubscriptionDisplayPrice(product: product)
        secondPriceLabel.text = PaywallModel.getSubscriptionDisplayPriceForWeek(product: product)
        discount80.isHidden = product.subscription?.subscriptionPeriod != .yearly
        discount100.isHidden = product.type != .nonConsumable
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        productSelectTrigger?(product)
    }
    
    func deg2rad(_ deg: CGFloat) -> CGFloat {
        deg * .pi / 180
    }
}
