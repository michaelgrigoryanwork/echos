//
//  OnboardingLoadingView.swift
//  Echos
//
//  Created by Michael Grigoryan on 02.09.25.
//

import UIKit
import SnapKit
import Lottie

final class OnboardingLoadingView: BaseView {
    // MARK: - Views
    private lazy var logoAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "logo_onboarding")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        return animationView
    }()
    
    private lazy var titleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchosString.Onboarding.Loading.title,
                font: EchosFont.unboundedBold(size: 54).uiFont,
                textColor: .echosBlack
            )
        )
        return label
    }()
    
    private lazy var subtitleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchosString.Onboarding.Loading.subtitle,
                font: EchosFont.unboundedBold(size: 16).uiFont,
                textColor: .echosBlack
            )
        )
        return label
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .echosBlack
        return view
    }()
    
    // MARK: - Properties
    private var loadingWidthConstraint: Constraint?
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.layer.cornerRadius = loadingView.bounds.height / 2
    }
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        addSubviews(logoAnimationView, titleLabel, subtitleLabel, loadingView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoAnimationView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(subtitleLabel.snp.top).inset(-10.0)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(loadingView.snp.top).offset(-178.0)
        }
        
        loadingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6.0)
            loadingWidthConstraint = $0.width.equalTo(24.0).constraint
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8.0)
        }
        logoAnimationView.play()
    }
    
    // MARK: - Methods
    func startLoading(
        duration: TimeInterval = 5.0,
        completion: @escaping (Bool) -> Void
    ) {
        layoutIfNeeded()
        let targetWidth = bounds.width - 16.0 * 2
        loadingWidthConstraint?.update(offset: targetWidth)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.layoutIfNeeded()
            },
            completion: completion
        )
    }
}
