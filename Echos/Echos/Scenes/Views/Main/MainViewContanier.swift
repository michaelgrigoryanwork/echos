//
//  MainViewContanier.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import UIKit
import SnapKit

final class MainViewContanier: BaseView, DayStripCalendarViewDelegate {
    
    var settingsTrigger: (() -> Void)?
    var onMoodSelected: ((Mood) -> Void)?
    var onMoodSendTapped: ((Mood) -> Void)?
    var onCommentTapped: ((Mood?) -> Void)?
    var onChangeSelectionTapped: (() -> Void)?
    var onListenTapped: (() -> Void)?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaMedium(size: 32).uiFont
        label.textAlignment = .left
        return label
    }()
    
    private let calendarView = DayStripCalendarView()
    private let emotionalView = EmotionalView()
    private let moodSelectionView = MoodSelectionView()
    private let moodResultView = MoodResultView()
    private let phraseOfDayView = PhraseOfDayView()
    private let meditationView = MeditationView()
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        setupView()
        setupClosure()
    }
    
    private func setupView() {
        backgroundColor = .mainBackground
        addSubviews(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubviews(titleLabel)
        scrollView.addSubviews(mainStackView)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        mainStackView.addArrangedSubviews(calendarView, emotionalView, moodSelectionView, moodResultView, phraseOfDayView, meditationView)
        
        calendarView.delegate = self
        calendarView.currentDate = Date()
        
        calendarView.stampedDates = [
            Date()
        ]
        
        calendarView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        setupCurrentDateUI()
    }
    
    private var selectionCalendarDate: Date?
    private let calendar = Calendar.current
    
    
    
    func calendarView(_ view: DayStripCalendarView, didSelect date: Date) {
        let hasMood = MoodDayStorage.shared.hasMood(on: date)
        let entries = MoodDayStorage.shared.moods(for: date)
        selectionCalendarDate = date
        
        let models = getModelsMood(date: date)
        let day = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        let text = DateHelper.string(from: Date())

        if day == today {
            setupCurrentDateUI()
        } else {
            if entries.count == 0 {
                moodResultView.isHidden = true
                moodSelectionView.isHidden = true
                emotionalView.setupEmotionalView(isData: models.count != 0, text: text, model: models)
            } else {
                moodResultView.isHidden = false
                moodSelectionView.isHidden = true
                moodResultView.configure(with: models.last?.mood ?? .good, isLimited: entries.count >= 5, notCuurentDate: true)
                emotionalView.setupEmotionalView(isData: models.count != 0, text: text, model: models)
            }
        }
        
        print("Selected:", hasMood)
        print("Mood:", entries)
    }
    
    private func setupCurrentDateUI() {
        let models = getModelsMood(date: Date())
        let text = DateHelper.string(from: Date())
        
        emotionalView.setupEmotionalView(isData: models.count != 0, text: text, model: models)
        if models.count >= 5 {
            moodResultView.configure(with: models.last?.mood ?? .good, isLimited: models.count >= 5, notCuurentDate: false)
            moodResultView.isHidden = false
            moodSelectionView.isHidden = true
        } else {
            if models.count == 0 {
                moodResultView.isHidden = true
                moodSelectionView.isHidden = false
            } else {
                moodSelectionView.isHidden = true
                moodResultView.isHidden = false
                moodResultView.configure(with: models.last?.mood ?? .good, isLimited: models.count >= 5, notCuurentDate: false)
            }
        }
    }
    
    private func chnageSelectionMood() {
        moodResultView.isHidden = true
        moodSelectionView.isHidden = false
    }
    
    private func getModelsMood(date: Date) -> [MoodModel] {
        return MoodDayStorage.shared.moods(for: date)
    }
    
    func setupName(name: String) {
        titleLabel.text = name
    }
    
    func setupClosure() {
        emotionalView.settingsTrigger = { [weak self] in
            guard let self else { return }
            self.settingsTrigger?()
        }
        
        emotionalView.onBubbleTap = { [weak self] mood, index in
            guard let self else { return }
            
        }
        
        moodSelectionView.onMoodSelected = { [weak self] mode in
            guard let self else { return }
            onMoodSelected?(mode)
        }
        
        moodSelectionView.onSendTapped = { [weak self] mode in
            guard let self else { return }
            onMoodSendTapped?(mode)
        }
        
        moodSelectionView.onCommentTapped = { [weak self] mode in
            guard let self else { return }
            onCommentTapped?(mode)
        }
        moodResultView.onChangeTapped = {[weak self] in
            guard let self else { return }
            onChangeSelectionTapped?()
            chnageSelectionMood()
        }
        
        meditationView.onListenTapped = { [weak self] in
            guard let self else { return }
            onListenTapped?()
        }
    }
    
    func saveMoodAction(mood: Mood) {
        let model = getModelsMood(date: selectionCalendarDate ?? Date())
        setupCurrentDateUI()
        moodResultView.configure(with: model.last?.mood ?? .good, isLimited: model.count >= 5, notCuurentDate: false)
        moodResultView.alpha = 0
        moodResultView.isHidden = false
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            self.moodSelectionView.alpha = 0
            
            self.moodResultView.alpha = 1
        }, completion: { _ in
            self.moodSelectionView.isHidden = true
            self.moodSelectionView.alpha = 1
        })
    }
}
