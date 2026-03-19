//
//  AuthorizationView.swift
//  Echos
//
//  Created by Michael Grigoryan on 03.09.25.
//

import UIKit
import Lottie

final class AuthorizationView: BaseView {
    
    // MARK: - Views
    private lazy var logoAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "logo_onboarding")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        return animationView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .echosBlack
        return view
    }()
    
    private lazy var titleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchosString.Authorization.title,
                font: EchosFont.helveticaMedium(size: 32).uiFont,
                textColor: .echosWhite,
                textAlignment: .left
            )
        )
        return label
    }()
    
    private lazy var subtitleLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchosString.Authorization.subtitle,
                font: EchosFont.helveticaMedium(size: 14).uiFont,
                textColor: .echosWhite,
                textAlignment: .left
            )
        )
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .echosWhite25
        return view
    }()
    
    private lazy var loginOrRegisterLabel: EchosLabel = {
        let label = EchosLabel(
            echosLabelConfig: .init(
                title: EchosString.Authorization.loginOrRegister,
                font: EchosFont.helveticaMedium(size: 20).uiFont,
                textColor: .echosWhite
            )
        )
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackiew = UIStackView()
        stackiew.axis = .vertical
        stackiew.distribution = .fillEqually
        stackiew.spacing = 10.0
        return stackiew
    }()
    
    private lazy var authWithGoogleButton: EchosButton = {
        let button = EchosButton(
            echosButtonState: .normal(
                title: EchosString.Authorization.authWithGoogle,
                image: EchosImage.Authorization.googleIcon,
                config: .init(
                    borderWidth: 1.0,
                    borderColor: .echosWhite,
                    font: EchosFont.helveticaMedium(size: 16).uiFont,
                    backgroundColor: .echosBlack,
                    titleColor: .echosWhite
                )
            )
        )
        return button
    }()
    
    private lazy var authWithAppleButton: EchosButton = {
        let button = EchosButton(
            echosButtonState: .normal(
                title: EchosString.Authorization.authWithApple,
                image: EchosImage.Authorization.appleIcon,
                config: .init(
                    borderWidth: 1.0,
                    borderColor: .echosWhite,
                    font: EchosFont.helveticaMedium(size: 16).uiFont,
                    backgroundColor: .echosBlack,
                    titleColor: .echosWhite,
                )
            )
        )
        return button
    }()

    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.roundCorners(
            [.topLeft, .topRight],
            radius: 32.0
        )
    }

    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        buttonsStackView.addArrangedSubviews(authWithAppleButton, authWithGoogleButton)
        
        containerView.addSubviews(titleLabel, subtitleLabel, separatorView, loginOrRegisterLabel, buttonsStackView)
        
        addSubviews(logoAnimationView, containerView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoAnimationView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(containerView.snp.top).offset(-26.0)
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(1.0)
        }
        
        loginOrRegisterLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(24.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(loginOrRegisterLabel.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24.0)
        }
        logoAnimationView.play()
    }
    
    // MARK: - Methods
}

// MARK: - Actions
extension AuthorizationView {
    func onAuthWithAppleButtonTap(_ closure: @escaping () -> Void) {
        authWithAppleButton.onTap(closure)
    }
    
    func onAuthWithGoogleButtonTap(_ closure: @escaping () -> Void) {
        authWithGoogleButton.onTap(closure)
    }
}
