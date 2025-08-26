//
//  UIView+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

extension UIView {
    // MARK: - Methods
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
