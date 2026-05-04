//
//  HomeScreenStatsView.swift
//  Echos
//
//  Created by Emma on 19.11.25.
//

import UIKit

final class HomeScreenStatsView: BaseView {
    
    // MARK: - Data
    
    private var days: [MoodDay] = []
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "statistics_view_background")
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.backgroundColor = .echosStatisticsPink
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "home.stats.mood_statistics".localized()
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaMedium(size: 24).uiFont
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Большую часть месяца у тебя было отличное настроение, так держать! Продолжай в том же духе, у тебя все получится!".localized()
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaRegular(size: 14).uiFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = MoodCalendarFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(MoodDayCell.self,
                    forCellWithReuseIdentifier: MoodDayCell.reuseId)
        return cv
    }()
    
    private lazy var legendStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupView()
        setupLegend()
        generateCurrentMonthRealData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLegend()
        
        let columns: CGFloat = 7
        let spacing: CGFloat = 8
        let totalSpacing = spacing * (columns - 1)
        let width = collectionView.bounds.width
        let itemWidth = (width - totalSpacing) / columns
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(itemWidth * 6)
        }
    }

    
    func setupView() {
        backgroundColor = .mainBackground
        addSubviews(backgroundImageView)
        addSubviews(scrollView)
        scrollView.addSubviews(backgroundView)
        backgroundView.addSubviews(titleLabel, calendarView, bottomLabel)
        
        backgroundImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(calendarView)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        calendarView.addSubviews(collectionView, legendStackView)
        
        legendStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
    }
    
    private func setupLegend() {
        legendStackView.arrangedSubviews.forEach {
            legendStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        let order: [MoodType] = [.great, .good, .normal, .medium, .bad, .skipped]
        let items = order.map { makeLegendItem(for: $0) }
        let availableWidth = legendStackView.bounds.width > 0
            ? legendStackView.bounds.width
            : UIScreen.main.bounds.width - 40
        
        let rowSpacing: CGFloat = 21
        
        func makeRowStack() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = rowSpacing
            stack.distribution = .fill
            stack.alignment = .leading
            return stack
        }
        
        var currentRow = makeRowStack()
        var currentRowWidth: CGFloat = 0
        
        for (index, item) in items.enumerated() {
            let itemSize = item.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let itemWidth = itemSize.width
            let extraSpacing: CGFloat = currentRow.arrangedSubviews.isEmpty ? 0 : rowSpacing
            let newWidth = currentRowWidth + extraSpacing + itemWidth
            if newWidth > availableWidth, !currentRow.arrangedSubviews.isEmpty {
                legendStackView.addArrangedSubview(currentRow)
                currentRow = makeRowStack()
                currentRowWidth = 0
            }
            currentRow.addArrangedSubview(item)
            currentRowWidth += extraSpacing + itemWidth
            
            if index == items.count - 1 {
                legendStackView.addArrangedSubview(currentRow)
            }
        }
    }
    
    private func makeLegendItem(for mood: MoodType) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 4
        container.distribution = .fill
        container.alignment = .leading
        
        let imageView = UIImageView()
        imageView.image = mood.dotIcon
        imageView.tintColor = mood.color
        imageView.tintColor = mood.color
        imageView.snp.makeConstraints { $0.size.equalTo(12) }
        
        let label = UILabel()
        label.text = mood.title
        label.font = EchosFont.helveticaRegular(size: 12).uiFont
        label.textColor = .emotionalGreat
        label.textAlignment = .left
        
        container.addArrangedSubview(imageView)
        container.addArrangedSubview(label)
        return container
    }
    
    func configure(days: [MoodDay]) {
        self.days = days
        collectionView.reloadData()
    }
    
    private func generateCurrentMonthRealData() {
        let calendar = Calendar.current
        let now = Date()
        let count = calendar.numberOfDays(in: now)
        
        var result: [MoodDay] = []
        
        for day in 1...count {
            var comps = calendar.dateComponents([.year, .month], from: now)
            comps.day = day
            guard let date = calendar.date(from: comps) else { continue }
            
            let moods = MoodDayStorage.shared.moods(for: date)
            
            let moodType: MoodType
            if let last = moods.sorted(by: { $0.date < $1.date }).last {
                moodType = last.mood.asMoodType
            } else {
                moodType = .skipped 
            }
            
            result.append(MoodDay(date: date, mood: moodType))
        }
        
        configure(days: result)
    }

}

struct MoodDay {
    let date: Date
    let mood: MoodType
}


final class MoodCalendarFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let columns: CGFloat = 7
        let spacing: CGFloat = 8
        let contentInset = collectionView.contentInset.left + collectionView.contentInset.right
        let sectionInsetHorizontal = sectionInset.left + sectionInset.right
        
        let availableWidth = collectionView.bounds.width
            - contentInset
            - sectionInsetHorizontal
        
        let totalSpacing = spacing * (columns - 1)
        
        let itemWidth = floor((availableWidth - totalSpacing) / columns)
        
        itemSize = CGSize(width: itemWidth, height: itemWidth)
        minimumInteritemSpacing = spacing
        minimumLineSpacing = spacing
        scrollDirection = .vertical
        estimatedItemSize = .zero
    }
}


extension HomeScreenStatsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoodDayCell.reuseId,
            for: indexPath
        ) as! MoodDayCell
        let day = days[indexPath.item]
        cell.configure(with: day.mood)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
enum MoodType: CaseIterable {
    case great
    case good
    case normal
    case medium
    case bad
    case skipped
}

extension MoodType {
    var colorName: String {
        switch self {
        case .great:   return "emotionalGreat"
        case .good:    return "emotionalGood"
        case .normal:  return "emotionalNormal"
        case .medium:  return "emotionalMedium"
        case .bad:     return "emotionalBad"
        case .skipped: return "emotionalSkipeedDay"
        }
    }
    
    var color: UIColor {
        UIColor(named: colorName) ?? .black
    }
    
    var title: String {
        switch self {
        case .great:   return "Отличное"
        case .good:    return "Хорошее"
        case .normal:  return "Нормальное"
        case .medium:  return "Не очень"
        case .bad:     return "Плоховато"
        case .skipped: return "Пропущенный день"
        }
    }
//    
//    var icon: UIImage? {
//        UIImage(named: "emotional_icon")
//    }
    
    var dotIcon: UIImage? {
        UIImage(named: "dot_icon")
    }
}
