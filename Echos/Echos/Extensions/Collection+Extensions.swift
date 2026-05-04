//
//  Collection+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 29.08.25.
//

import Foundation

extension Collection {
    // MARK: - Methods
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
