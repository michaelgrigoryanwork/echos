//
//  DayStripCalendarView.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import UIKit
import JTAppleCalendar
import SnapKit

// MARK: - Delegate

protocol DayStripCalendarViewDelegate: AnyObject {
    func calendarView(_ view: DayStripCalendarView, didSelect date: Date)
}

// MARK: - View

final class DayStripCalendarView: UIView {

    weak var delegate: DayStripCalendarViewDelegate?

    var stampedDates: Set<Date> = [] {
        didSet { monthView.reloadData() }
    }

    private let monthView = JTACMonthView()
    private let calendar = Calendar(identifier: .gregorian)

    private let weekdayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "EE"
        return df
    }()

    private var startDate: Date
    private var endDate: Date

    // MARK: - Init

    /// По умолчанию: от сегодня -7 до +14 дней
    override init(frame: CGRect) {
        let today = Date()
        let cal = Calendar(identifier: .gregorian)
        self.startDate = cal.date(byAdding: .day, value: -7, to: today) ?? today
        self.endDate   = cal.date(byAdding: .day, value: 14, to: today) ?? today
        super.init(frame: frame)
        setup()
    }

    /// Если хочешь свой диапазон
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func scrollToToday(animated: Bool = true) {
        monthView.scrollToDate(Date(), animateScroll: animated)
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear

        addSubview(monthView)
        monthView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        monthView.calendarDataSource = self
        monthView.calendarDelegate = self

        monthView.scrollDirection = .horizontal
        monthView.showsHorizontalScrollIndicator = false
        monthView.showsVerticalScrollIndicator = false
        monthView.allowsMultipleSelection = false
        monthView.scrollingMode = .stopAtEachSection
        monthView.isPagingEnabled = false
        monthView.minimumLineSpacing = 8
        monthView.minimumInteritemSpacing = 8

        monthView.register(
            DayStripCell.self,
            forCellWithReuseIdentifier: DayStripCell.reuseId
        )
    }
}

// MARK: - JTACMonthViewDataSource

extension DayStripCalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 1,
            calendar: self.calendar,
            generateInDates: .forAllMonths,
            generateOutDates: .off,
            firstDayOfWeek: .monday,
            hasStrictBoundaries: false
        )
    }
}

// MARK: - JTACMonthViewDelegate

extension DayStripCalendarView: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView,
                  willDisplay cell: JTAppleCalendar.JTACDayCell,
                  forItemAt date: Date,
                  cellState: JTAppleCalendar.CellState,
                  indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTACMonthView,
                  cellForItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) -> JTACDayCell {

        guard let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: DayStripCell.reuseId,
            for: indexPath
        ) as? DayStripCell else {
            return JTACDayCell()
        }

        let isToday = self.calendar.isDateInToday(date)
        let hasStamp = stampedDates.contains { self.calendar.isDate($0, inSameDayAs: date) }

        let weekday = weekdayFormatter.string(from: date).uppercased()
        let dayNumber = cellState.text

        cell.configure(
            weekday: weekday,
            day: dayNumber,
            isSelected: cellState.isSelected,
            isToday: isToday,
            hasStamp: hasStamp,
            isWithinCurrentMonth: cellState.dateBelongsTo == .thisMonth
        )

        return cell
    }

    func calendar(_ calendar: JTACMonthView,
                  didSelectDate date: Date,
                  cell: JTACDayCell?,
                  cellState: CellState,
                  indexPath: IndexPath) {
        (cell as? DayStripCell)?.setSelected(true)
        delegate?.calendarView(self, didSelect: date)
    }

    func calendar(_ calendar: JTACMonthView,
                  didDeselectDate date: Date,
                  cell: JTACDayCell?,
                  cellState: CellState,
                  indexPath: IndexPath) {
        (cell as? DayStripCell)?.setSelected(false)
    }
}

// MARK: - Cell

final class DayStripCell: JTACDayCell {

    static let reuseId = "DayStripCell"
    private let normalBorderColor = UIColor.calendarBackground.cgColor
    private let selectedBorderColor = UIColor.calendarBorderSelection50.cgColor
    private let normalBackgroundColor = UIColor.calendarbackground30
    private let selectedBackgroundColor = UIColor.calendarBackground


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
    private let dayLabel:  UILabel = {
        let label = UILabel()
        label.font = EchosFont.helveticaMedium(size: 16).uiFont
        label.textColor = .echosBlack80
        return label
    }()
    private let stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.image = UIImage(named: "calendar_icon")
        return imageView
    }()

    private var isSelectedState: Bool = false {
        didSet { updateAppearance() }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(stampImageView)
        stampImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(4)
            make.width.height.equalTo(12)
        }

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

    // MARK: - Configure

    func configure(weekday: String,
                   day: String,
                   isSelected: Bool,
                   isToday: Bool,
                   hasStamp: Bool,
                   isWithinCurrentMonth: Bool) {

        weekdayLabel.text = weekday
        dayLabel.text = day

        stampImageView.isHidden = false

        // тут можешь добавить особый стиль "сегодня"
//        if isToday {
//            dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        } else {
//            dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        }

        // если дата не из текущего месяца — можно побледнить
        if !isWithinCurrentMonth {
            weekdayLabel.textColor = .echosBlack30
            dayLabel.textColor = .echosBlack80
        } else {
            weekdayLabel.textColor = .echosBlack30
            dayLabel.textColor = .echosBlack30
        }

        isSelectedState = isSelected
    }

    func setSelected(_ selected: Bool) {
        isSelectedState = selected
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

