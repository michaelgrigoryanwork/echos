//
//  CalendarDayCell.swift
//  Echos
//
//  Created by Emma on 26.02.26.
//

import UIKit
import JTAppleCalendar
import SnapKit

final class CalendarDayCell: JTACDayCell {

    static let reuseId = "DayStripCell"

    private let normalBorderColor = UIColor.calendarBackground.cgColor
    private let selectedBorderColor = UIColor.calendarBorderSelection50.cgColor
    private let normalBackgroundColor = UIColor.calendarbackground30
    private let selectedBackgroundColor = UIColor.calendarBackground

    private let stampSize: CGFloat = 10
    private let stampInset: CGFloat = 4
    private let stampOffsetX: CGFloat = 7
    private let stampOffsetY: CGFloat = 7

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.calendarBackground.cgColor
        view.backgroundColor = UIColor.calendarbackground30
        return view
    }()

    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaRegular(size: 11).uiFont
        label.textColor = .echosBlack30
        return label
    }()

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaMedium(size: 16).uiFont
        label.textColor = .echosBlack80
        return label
    }()

    private lazy var moodStampViews: [UIImageView] = (0..<3).map { _ in
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }

    private var isSelectedState: Bool = false {
        didSet { updateAppearance() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }

        moodStampViews.forEach { containerView.addSubview($0) }

        containerView.addSubview(weekdayLabel)
        containerView.addSubview(dayLabel)

        weekdayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }

        dayLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
    }

    func configure(dayDate: Date,
                   weekday: String,
                   day: String,
                   isSelected: Bool,
                   isToday: Bool,
                   hasStamp: Bool,
                   isWithinCurrentMonth: Bool) {

        let moods = MoodDayStorage.shared.moods(for: dayDate)

        weekdayLabel.text = weekday
        dayLabel.text = day

        if isWithinCurrentMonth {
            weekdayLabel.textColor = .echosBlack30
            dayLabel.textColor = .echosBlack80

            let canShowStamps = MoodDayStorage.shared.canAddMood(on: dayDate)
            applyMoodStamps(moods: moods, visible: canShowStamps)
        } else {
            weekdayLabel.textColor = .echosBlack30
            dayLabel.textColor = .echosBlack30
            applyMoodStamps(moods: [], visible: false)
        }

        isSelectedState = isSelected
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        applyMoodStamps(moods: [], visible: false)
        isSelectedState = false
    }

    func setSelected(_ selected: Bool) {
        isSelectedState = selected
    }

    private func applyMoodStamps(moods: [MoodModel], visible: Bool) {
        moodStampViews.forEach {
            $0.isHidden = true
            $0.image = nil
        }

        guard visible, !moods.isEmpty else { return }

        let lastThree = Array(moods.suffix(3))
        layoutMoodStamps(count: lastThree.count)

        for (index, mood) in lastThree.enumerated() {
            let stampView = moodStampViews[index]
            stampView.image = UIImage(named: mood.mood.iconName)
            stampView.isHidden = false
        }
    }

    private func layoutMoodStamps(count: Int) {
        moodStampViews.forEach { $0.snp.removeConstraints() }

        for (index, stampView) in moodStampViews.enumerated() {
            stampView.layer.zPosition = CGFloat(index)
        }

        func placeStamp(at index: Int, x: CGFloat, y: CGFloat) {
            let stampView = moodStampViews[index]
            stampView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(stampInset + x)
                make.top.equalToSuperview().offset(stampInset + y)
                make.width.height.equalTo(stampSize)
            }
        }

        switch count {
        case 1:
            placeStamp(at: 0, x: 0, y: 0)
        case 2:
            placeStamp(at: 0, x: 0, y: 0)
            placeStamp(at: 1, x: stampOffsetX, y: 0)
        default:
            placeStamp(at: 0, x: 0, y: 0)
            placeStamp(at: 1, x: stampOffsetX, y: 0)
            placeStamp(at: 2, x: stampOffsetX * 0.5, y: stampOffsetY)
        }
    }

    private func updateAppearance() {
        if isSelectedState {
            containerView.layer.borderColor = selectedBorderColor
            containerView.backgroundColor = selectedBackgroundColor
        } else {
            containerView.layer.borderColor = normalBorderColor
            containerView.backgroundColor = normalBackgroundColor
        }
    }
}
