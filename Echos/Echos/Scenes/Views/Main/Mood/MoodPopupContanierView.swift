//
//  EmotionalContanierView.swift
//  Echos
//
//  Created by Emma on 18.11.25.
//

import UIKit
import SnapKit

final class MoodPopupContanierView: BaseView {
    
    var onSendTapped: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    
    private lazy var bottomContanierView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
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
    
    private let textContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
        return view
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textColor = .echosBlack
        tv.font = EchosFont.helveticaRegular(size: 16).uiFont
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "emotional.mood.comment.placeholder".localized()
        label.textColor = .echosBlack30
        label.font = EchosFont.helveticaRegular(size: 16).uiFont
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.text = "0/200"
        label.textColor = .echosBlack30
        label.font = EchosFont.helveticaRegular(size: 12).uiFont
        return label
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
    
    private var textViewHeightConstraint: Constraint?
    private var bottomConstraint: Constraint?
    
    private var itemViews: [Mood: MoodSelectionItemView] = [:]
    
    override func setupViews() {
        super.setupViews()
        setupView()
        textView.delegate = self
        setupKeyboardHandling()
        setupTapToDismiss()
        setupPanToDismiss() 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        backgroundColor = .black60
        addSubviews(bottomContanierView)
        bottomContanierView.addSubviews(lineView)
        bottomContanierView.addSubviews(titleLabel)
        bottomContanierView.addSubviews(moodsStackView)
        bottomContanierView.addSubview(textContainerView)
        bottomContanierView.addSubviews(sendButton)
        
        bottomContanierView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            bottomConstraint = $0.bottom.equalToSuperview().inset(0).constraint
        }
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(6)
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(28)
        }
        
        moodsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        
        textContainerView.snp.makeConstraints { make in
            make.top.equalTo(moodsStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        textContainerView.addSubview(textView)
        textContainerView.addSubview(placeholderLabel)
        textContainerView.addSubview(counterLabel)
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            textViewHeightConstraint = make.height.equalTo(140).constraint
            make.bottom.equalToSuperview().inset(24)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top)
            make.leading.equalTo(textView.snp.leading).offset(2)
            make.trailing.lessThanOrEqualTo(textView.snp.trailing)
        }
        
        counterLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing)
            make.bottom.equalToSuperview().inset(6)
        }
        
        sendButton.snp.makeConstraints {
            $0.top.equalTo(textContainerView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomContanierView.layer.cornerRadius = 24
        bottomContanierView.layer.masksToBounds = true
        bottomContanierView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
    }
    
    private func updateCounterAndAppearance() {
        let count = textView.text.count
        counterLabel.text = "\(count)/200"
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        let fittingSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        let targetHeight = max(140, textView.sizeThatFits(fittingSize).height)
        textViewHeightConstraint?.update(offset: targetHeight)
        layoutIfNeeded()
        if count > 201 {
            textView.textColor = .echosRed
            counterLabel.textColor = .echosRed
            textContainerView.layer.borderColor = UIColor.echosRed.cgColor
        } else {
            textView.textColor = .echosBlack
            counterLabel.textColor = .echosBlack30
            textContainerView.layer.borderColor = UIColor.echosBlack30.cgColor
        }
    }
    
    
    func seletionMood(_ moodSelection: Mood) {
        Mood.allCases.forEach { mood in
            let item = MoodSelectionItemView()
            item.configure(
                iconName: mood.iconName,
                title: mood.titleKey.localized()
            )
            item.isSelected = (mood == moodSelection)
            item.tag = moodTag(mood)
            moodsStackView.addArrangedSubview(item)
            itemViews[mood] = item
        }
    }
    
    
    @objc private func handleSendTapped() {
        let text = textView.text ?? ""
        let textSave = text.replacingOccurrences(of: "\n", with: " ")
        onSendTapped?(textSave)
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

extension MoodPopupContanierView {
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardFrame = frameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height
        
        let safeBottom = safeAreaInsets.bottom
        let inset = max(0, keyboardHeight - safeBottom)
        
        bottomConstraint?.update(inset: inset + 10)
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        bottomConstraint?.update(inset: 0)
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func setupPanToDismiss() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.cancelsTouchesInView = false
        bottomContanierView.addGestureRecognizer(pan)
    }
    
    func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .changed:
            // двигаем только вниз
            let offsetY = max(0, translation.y)
            bottomContanierView.transform = CGAffineTransform(translationX: 0, y: offsetY)
            
            // чуть-чуть ослабляем фон
            let progress = min(1, offsetY / 300)
            backgroundColor = UIColor.black60.withAlphaComponent(1 - 0.4 * progress)
            
        case .ended, .cancelled:
            let offsetY = max(0, translation.y)
            let velocityY = gesture.velocity(in: self).y
            
            // критерий: либо сильно стянул вниз, либо быстрый свайп
            let shouldDismiss = offsetY > 140 || velocityY > 700
            
            if shouldDismiss {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {
                    self.bottomContanierView.transform =
                    CGAffineTransform(translationX: 0, y: self.bounds.height)
                    self.backgroundColor = .clear
                }, completion: { _ in
                    self.onDismiss?()
                })
            } else {
                // возвращаемся обратно
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.85,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                               animations: {
                    self.bottomContanierView.transform = .identity
                    self.backgroundColor = .black60
                }, completion: nil)
            }
            
        default:
            break
        }
    }
    
    @objc func handleBackgroundTap() {
        endEditing(true)
    }
}

extension MoodPopupContanierView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateCounterAndAppearance()
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if let current = textView.text as NSString? {
            let updated = current.replacingCharacters(in: range, with: text)
            return updated.count <= 202
        }
        return true
    }
}
