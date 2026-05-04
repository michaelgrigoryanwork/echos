//
//  GlassView.swift
//  Echos
//
//  Created by Emma on 26.02.26.
//

import UIKit

final class GlassView: BaseView {
    
    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 12).uiFont
        label.textColor = .echosBlack80
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        addSubviews(blurView, label)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(12)
        }
        
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
    }
    
    func setData(text: String) {
        label.text = text
    }
}
