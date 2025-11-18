//
//  PlayerView.swift
//  Echos
//
//  Created by Emma on 14.11.25.
//

import UIKit
import Lottie

final class PlayerView: BaseView {
    
    private let gradientLayer = CAGradientLayer()
    private let blurSpot1 = CALayer()
    private let blurSpot2 = CALayer()
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        setupView()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        blurSpot1.frame = CGRect(x: -80, y: -120, width: 300, height: 300)
        blurSpot2.frame = CGRect(x: bounds.width - 200,
                                 y: bounds.height - 200,
                                 width: 320, height: 320)
        blurSpot1.cornerRadius = blurSpot1.bounds.width / 2
        blurSpot2.cornerRadius = blurSpot2.bounds.width / 2
    }
    
    private func setupView() {
        backgroundColor = .clear
        gradientLayer.colors = [
            UIColor(red: 228/255, green: 220/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 200/255, green: 190/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        
        configureSpot(blurSpot1,
                      color: UIColor.white.withAlphaComponent(0.35))
        configureSpot(blurSpot2,
                      color: UIColor.white.withAlphaComponent(0.25))
    }
    
    private func configureSpot(_ layerSpot: CALayer, color: UIColor) {
        layerSpot.backgroundColor = color.cgColor
        layerSpot.shadowColor = color.cgColor
        layerSpot.shadowOpacity = 1
        layerSpot.shadowRadius = 80
        layerSpot.shadowOffset = .zero
        layer.addSublayer(layerSpot)
    }
}
