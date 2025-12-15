//
//  MoodClusterView.swift
//  Echos
//
//  Created by Emma on 24.11.25.
//

import UIKit
import Lottie

final class MoodClusterView: UIView {
    
    private var animationViews: [LottieAnimationView] = []
    private var bubbleButtons: [UIButton] = []
    private var moods: [MoodModel] = []
    private let maxItems = 5
    
    var onBubbleTap: ((MoodModel, Int) -> Void)?
    
    func configure(with moods: [MoodModel]) {
        clipsToBounds = false
        animationViews.forEach { $0.removeFromSuperview() }
        animationViews.removeAll()
        bubbleButtons.forEach { $0.removeFromSuperview() }
        bubbleButtons.removeAll()
        
        let limitedMoods = Array(moods.prefix(maxItems))
        self.moods = limitedMoods
        
        for (index, mood) in limitedMoods.enumerated() {
            let animationView = LottieAnimationView(name: mood.mood.animationName)
            animationView.loopMode = .loop
            animationView.animationSpeed = 1.5
            animationView.play()
            
            let bubbleButton = UIButton()
            bubbleButton.setImage(UIImage(named: "bubble_icon"), for: .normal)
            bubbleButton.tag = index
            bubbleButton.addTarget(self, action: #selector(bubbleTapped(_:)), for: .touchUpInside)
            bubbleButton.backgroundColor = .clear
            bringSubviewToFront(bubbleButton)
            bubbleButton.isUserInteractionEnabled = true
            
            let hasText = !(mood.text?.isEmpty ?? true)
            bubbleButton.isHidden = !hasText
            addSubview(animationView)
            addSubview(bubbleButton)
            animationViews.append(animationView)
            bubbleButtons.append(bubbleButton)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !animationViews.isEmpty else { return }

        let positions = positions(for: animationViews.count)
        let positionsBubbles = bubblsPositions(for: animationViews.count)

        let bigSide = min(bounds.width, bounds.height)
        let smallSide = bigSide * 0.5

        for (index, (imageView, point)) in zip(animationViews, positions).enumerated() {
            let side = (animationViews.count == 1 || index == 0) ? bigSide : smallSide

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
        bubbleButtons.forEach { bringSubviewToFront($0) }
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
            return [CGPoint(x: 0.7, y: 0.2)]
        case 2:
            return [CGPoint(x: 0.7, y: 0.2),
                    CGPoint(x: 0.13, y: 0.57)]
        case 3:
            return [
                CGPoint(x: 0.3,  y: 0.15),
                CGPoint(x: 0.13, y: 0.57),
                CGPoint(x: 0.85, y: 0.25)
            ]
        case 4:
            return [
                CGPoint(x: 0.3,  y: 0.15),
                CGPoint(x: 0.13, y: 0.57),
                CGPoint(x: 0.85, y: 0.25),
                CGPoint(x: 0.85, y: 0.9)
            ]
        case 5:
            return [
                CGPoint(x: 0.85, y: 0.5),
                CGPoint(x: 0.13, y: 0.57),
                CGPoint(x: 0.8, y: 0.05),
                CGPoint(x: 0.65, y: 0.93),
                CGPoint(x: 0.1, y: 0.1)
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
            return [CGPoint(x: 0.5, y: 0.5),
                    CGPoint(x: 0.25, y: 0.7)]
        case 3:
            return [
                CGPoint(x: 0.5,  y: 0.5),
                CGPoint(x: 0.25, y: 0.7),
                CGPoint(x: 0.7, y: 0.18)
            ]
        case 4:
            return [
                CGPoint(x: 0.5,  y: 0.5),
                CGPoint(x: 0.25, y: 0.7),
                CGPoint(x: 0.7, y: 0.18),
                CGPoint(x: 0.72, y: 0.8)
            ]
        case 5:
            return [
                CGPoint(x: 0.5,  y: 0.5),
                CGPoint(x: 0.25, y: 0.7),
                CGPoint(x: 0.7, y: 0.18),
                CGPoint(x: 0.72, y: 0.8),
                CGPoint(x: 0.25, y: 0.18)
            ]
        default:
            return []
        }
    }
}

