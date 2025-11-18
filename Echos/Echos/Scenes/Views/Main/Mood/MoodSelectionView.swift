//
//  MoodSelectionView.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import UIKit
import SnapKit

enum Mood: CaseIterable {
    case bad
    case medium
    case normal
    case good
    case great
    
    var titleKey: String {
        switch self {
        case .bad:    return "emotional.mood.bad"
        case .medium: return "emotional.mood.medium"
        case .normal: return "emotional.mood.normal"
        case .good:   return "emotional.mood.good"
        case .great:  return "emotional.mood.great"
        }
    }
    
    var iconName: String {
        switch self {
        case .bad:    return "bag_emotional_icon"
        case .medium: return "medium_emotional_icon"
        case .normal: return "normal_emotional_icon"
        case .good:   return "good_emotional_icon"
        case .great:  return "great_emotional_icon"
        }
    }
}

final class MoodSelectionView: BaseView {
    
    // колбэки наружу
    var onMoodSelected: ((Mood) -> Void)?
    var onSendTapped: ((Mood) -> Void)?
    var onCommentTapped: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "emotional.mood.question.title".localized()
        label.textAlignment = .left
        label.textColor = .echosBlack
        label.font = EchosFont.helveticaMedium(size: 24).uiFont
        return label
    }()
    
    private lazy var moodsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("emotional.mood.comment.placeholder".localized(), for: .normal)
        button.titleLabel?.font = EchosFont.helveticaRegular(size: 16).uiFont
        button.backgroundColor = .white
        button.setTitleColor(.echosBlack30, for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("emotional.mood.send".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = EchosFont.helveticaMedium(size: 16).uiFont
        button.backgroundColor = .black
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleSendTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - State
    
    private var itemViews: [Mood: MoodSelectionItemView] = [:]
    private var selectedMood: Mood? {
        didSet {
            updateSelection()
            showCommentIfNeeded()
        }
    }    
    
    // MARK: - Lifecycle
    
    override func setupViews() {
        super.setupViews()
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .calendarBackground
        layer.cornerRadius = 24
        clipsToBounds = true
        addSubviews(titleLabel)
        addSubviews(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(moodsStackView)
        contentStackView.addArrangedSubview(commentButton)
        contentStackView.addArrangedSubview(sendButton)
        
        centerView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        commentButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        setupMoods()
        setupSendButton()
    }
    
    private func setupMoods() {
        Mood.allCases.forEach { mood in
            let item = MoodSelectionItemView()
            item.configure(
                iconName: mood.iconName,
                title: mood.titleKey.localized()
            )
            item.tag = moodTag(mood)
            item.addTarget(self, action: #selector(moodTapped(_:)), for: .touchUpInside)
            moodsStackView.addArrangedSubview(item)
            itemViews[mood] = item
        }
    }
    
    private func setupSendButton() {
        contentStackView.addArrangedSubview(centerView)
        contentStackView.addArrangedSubview(commentButton)
        contentStackView.addArrangedSubview(sendButton)
        centerView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        commentButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        centerView.isHidden = true
        commentButton.isHidden = true
        sendButton.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc private func moodTapped(_ sender: UIControl) {
        guard let mood = moodFromTag(sender.tag) else { return }
        selectedMood = mood
        onMoodSelected?(mood)
    }
    
    @objc private func handleCommentTapped() {
        onCommentTapped?()
    }
    
    @objc private func handleSendTapped() {
        guard let mood = selectedMood else { return }
        onSendTapped?(mood)
    }
    
    private func updateSelection() {
        itemViews.forEach { mood, view in
            view.isSelected = (mood == selectedMood)
        }
    }
    
    private func showCommentIfNeeded() {
        guard selectedMood != nil else { return }
        // если уже показано — ничего не делаем
        guard sendButton.isHidden else { return }
        
        commentButton.isHidden = false
        sendButton.isHidden = false
        centerView.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Tag helpers
    
    private func moodTag(_ mood: Mood) -> Int {
        switch mood {
        case .bad:    return 1
        case .medium: return 2
        case .normal: return 3
        case .good:   return 4
        case .great:  return 5
        }
    }
    
    private func moodFromTag(_ tag: Int) -> Mood? {
        switch tag {
        case 1: return .bad
        case 2: return .medium
        case 3: return .normal
        case 4: return .good
        case 5: return .great
        default: return nil
        }
    }
}

// MARK: - Item (иконка + подпись)

final class MoodSelectionItemView: UIControl {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(54)
        }
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        titleLabel.textAlignment = .center
        titleLabel.font = EchosFont.helveticaRegular(size: 12).uiFont
        titleLabel.textColor = .black50
        
        isSelected = true
    }
    
    func configure(iconName: String, title: String) {
        iconImageView.image = UIImage(named: iconName)
        titleLabel.text = title
    }
    
    private func updateAppearance() {
        if isSelected {
            iconImageView.alpha = 1.0
            titleLabel.textColor = .black50
        } else {
            iconImageView.alpha = 0.25
            titleLabel.textColor = .echosBlack.withAlphaComponent(0.2)
        }
    }
}
