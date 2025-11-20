//
//  MoodDayCell.swift
//  Echos
//
//  Created by Emma on 20.11.25.
//

import UIKit

final class MoodDayCell: UICollectionViewCell {
    static let reuseId = "MoodDayCell"
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "emitional_icon")
//        iconView.tintColor = .emotionalSkipeedDay
        return iconView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with mood: MoodType) {
        iconView.tintColor = mood.color
    }
}
