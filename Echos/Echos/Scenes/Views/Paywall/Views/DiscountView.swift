//
//  DiscountView.swift
//  Echos
//
//  Created by Emma on 26.02.26.
//

import UIKit

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
