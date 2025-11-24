//
//  MoodClusterView.swift
//  Echos
//
//  Created by Emma on 24.11.25.
//

import UIKit

final class MoodClusterView: UIView {
    
    private var imageViews: [UIImageView] = []
    private var bubbleButtons: [UIButton] = []
    private var moods: [MoodModel] = []
    private let maxItems = 5
    
    var onBubbleTap: ((MoodModel, Int) -> Void)?
    
    func configure(with moods: [MoodModel]) {
        clipsToBounds = false
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        bubbleButtons.forEach { $0.removeFromSuperview() }
        bubbleButtons.removeAll()
        
        let limitedMoods = Array(moods.prefix(maxItems))
        self.moods = limitedMoods
        
        for (index, mood) in limitedMoods.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: mood.mood.iconName)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .clear
            
            imageView.layer.shadowColor = mood.mood.color.cgColor
            imageView.layer.shadowOpacity = 0.5
            imageView.layer.shadowRadius = 8
            imageView.layer.shadowOffset = .zero
            
            let bubbleButton = UIButton()
            bubbleButton.setImage(UIImage(named: "bubble_icon"), for: .normal)
            bubbleButton.tag = index
            bubbleButton.addTarget(self, action: #selector(bubbleTapped(_:)), for: .touchUpInside)
            bubbleButton.backgroundColor = .clear
            bringSubviewToFront(bubbleButton)
            bubbleButton.isUserInteractionEnabled = true
            
            let hasText = !(mood.text?.isEmpty ?? true)
            bubbleButton.isHidden = !hasText
            addSubview(imageView)
            addSubview(bubbleButton)
            imageViews.append(imageView)
            bubbleButtons.append(bubbleButton)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !imageViews.isEmpty else { return }
        let positions = positions(for: imageViews.count)
        let positionsBubbles = bubblsPositions(for: imageViews.count)
        let side: CGFloat
        if imageViews.count == 1 {
            side = min(bounds.width, bounds.height)
        } else {
            side = min(bounds.width, bounds.height) * 0.5
        }
        for (imageView, point) in zip(imageViews, positions) {
            let size = CGSize(width: side, height: side)
            let origin = CGPoint(
                x: bounds.width * point.x - size.width / 2,
                y: bounds.height * point.y - size.height / 2
            )
            imageView.frame = CGRect(origin: origin, size: size)
        }
        
        for (button, point) in zip(bubbleButtons, positionsBubbles) {
            let size = CGSize(width: 38, height: 38)
            let origin = CGPoint(
                x: bounds.width * point.x - size.width / 2,
                y: bounds.height * point.y - size.height / 2
            )
            button.frame = CGRect(origin: origin, size: size)
        }
    }
    
    @objc private func bubbleTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0, index < moods.count else { return }
        let mood = moods[index]
        onBubbleTap?(mood, index)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inset: CGFloat = -30
        let largerBounds = bounds.insetBy(dx: inset, dy: inset)
        return largerBounds.contains(point)
    }
    
    private func bubblsPositions(for count: Int) -> [CGPoint] {
        switch count {
        case 1:
            return [CGPoint(x: 0.95, y: 0.2)]
        case 2:
            return [CGPoint(x: 0.085, y: 0.84),
                    CGPoint(x: 0.88, y: 0.215)]
        case 3:
            return [
                CGPoint(x: 0.2,  y: 0.05),
                CGPoint(x: 0.08, y: 0.93),
                CGPoint(x: 1, y: 0.85)
            ]
        case 4:
            return [
                CGPoint(x: 0.1, y: 0.1),
                CGPoint(x: 1.05, y: 0.2),
                CGPoint(x: 0.05, y: 0.9),
                CGPoint(x: 0.97, y: 0.9)
            ]
        case 5:
            return [
                CGPoint(x: 0.1, y: 0.1),
                CGPoint(x: 1, y: 0.1),
                CGPoint(x: -0.05, y: 0.9),
                CGPoint(x: 1.13, y: 0.84),
                CGPoint(x: 0.53, y: 1.15)
            ]
        default:
            return []
        }
    }
    
    private func positions(for count: Int) -> [CGPoint] {
        switch count {
        case 1:
            return [CGPoint(x: 0.5, y: 0.5)]
        case 2:
            return [CGPoint(x: 0.35, y: 0.65),
                    CGPoint(x: 0.65, y: 0.35)]
        case 3:
            return [
                CGPoint(x: 0.5,  y: 0.28),
                CGPoint(x: 0.33, y: 0.70),
                CGPoint(x: 0.67, y: 0.65)
            ]
        case 4:
            return [
                CGPoint(x: 0.38, y: 0.34),
                CGPoint(x: 0.73 , y: 0.36),
                CGPoint(x: 0.32, y: 0.68),
                CGPoint(x: 0.65, y: 0.72)
            ]
        case 5:
            return [
                CGPoint(x: 0.34, y: 0.36),
                CGPoint(x: 0.68, y: 0.26),
                CGPoint(x: 0.24, y: 0.68),
                CGPoint(x: 0.84, y: 0.6),
                CGPoint(x: 0.50, y: 0.8)
            ]
        default:
            return []
        }
    }
}

