//
//  BaseView.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

class BaseView: UIView {
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupUI()
    }
    
    // MARK: - Setup
    func setupViews() {
        backgroundColor = .echosBeige
    }
    
    func setupConstraints() {
        
    }
}

// MARK: - Setup
private extension BaseView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
}
