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
    var onSendTapped: ((Mood) -> Void)?
    var onCommentTapped: (() -> Void)?
    var onChangeSelectionTapped: (() -> Void)?
    var onListenTapped: (() -> Void)?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
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
        scrollView.addSubviews(calendarView)
        scrollView.addSubviews(emotionalView)
        scrollView.addSubviews(moodSelectionView)
        scrollView.addSubviews(moodResultView)
        scrollView.addSubviews(phraseOfDayView)
        scrollView.addSubviews(meditationView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        calendarView.delegate = self
        
        calendarView.stampedDates = [
            Date()
        ]
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.trailing.leading.equalTo(titleLabel)
            $0.height.equalTo(60)
        }
        
        emotionalView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
        }
        
        moodSelectionView.snp.makeConstraints {
            $0.top.equalTo(emotionalView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        moodResultView.snp.makeConstraints {
            $0.top.equalTo(moodSelectionView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        phraseOfDayView.snp.makeConstraints {
            $0.top.equalTo(moodResultView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        meditationView.snp.makeConstraints {
            $0.top.equalTo(phraseOfDayView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        moodResultView.configure(with: .good)
    }
    
    func calendarView(_ view: DayStripCalendarView, didSelect date: Date) {
        print("Selected:", date)
    }
    
    func setupName(name: String) {
        titleLabel.text = name
    }
    
    func setupClosure() {
        emotionalView.settingsTrigger = { [weak self] in
            guard let self else { return }
            self.settingsTrigger?()
        }
        
        moodSelectionView.onMoodSelected = { [weak self] mode in
            guard let self else { return }
            onMoodSelected?(mode)
        }
        
        moodSelectionView.onSendTapped = { [weak self] mode in
            guard let self else { return }
            onSendTapped?(mode)
        }
        
        moodSelectionView.onCommentTapped = { [weak self] in
            guard let self else { return }
            onCommentTapped?()
        }
        moodResultView.onChangeTapped = {[weak self] in
            guard let self else { return }
            onChangeSelectionTapped?()
        }
        
        meditationView.onListenTapped = { [weak self] in
            guard let self else { return }
            onListenTapped?()
        }
    }
}
