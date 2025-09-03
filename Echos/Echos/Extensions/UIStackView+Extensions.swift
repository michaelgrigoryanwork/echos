//
//  UIStackView+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 03.09.25.
//

import UIKit

extension UIStackView {
    // MARK: - Methods
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
