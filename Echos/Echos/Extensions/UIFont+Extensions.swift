//
//  UIFont+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

enum EchosFont {
    // MARK: - Cases
    case helveticaRegular(size: CGFloat)
    case helveticaMedium(size: CGFloat)
    case helveticaBold(size: CGFloat)
    
    case unboundedBold(size: CGFloat)
    case unboundedSemiBold(size: CGFloat)

    
    // MARK: - Properties
    var uiFont: UIFont {
        switch self {
            case .helveticaRegular(let size):
            return .init(name: "HelveticaNeue", size: size) ?? .systemFont(ofSize: size, weight: .regular)
        case .helveticaMedium(let size):
            return .init(name: "HelveticaNeue-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
        case .helveticaBold(let size):
            return .init(name: "HelveticaNeue-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        case .unboundedBold(size: let size):
            return .init(name: "Unbounded-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        case .unboundedSemiBold(size: let size):
            return .init(name: "Unbounded-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        }
    }
}
