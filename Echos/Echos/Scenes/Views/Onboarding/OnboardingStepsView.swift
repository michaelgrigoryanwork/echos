//
//  OnboardingStepsView.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class OnboardingStepsView: BaseView {
    // MARK: - Handlers
    private var onSegmentedProgressBarHighlightChanged: ((Int) -> Void)?

    // MARK: - Views
    private lazy var segmentedProgressBar: EchosSegmentedProgressBar = {
        let progressBar = EchosSegmentedProgressBar(
            echosSegmentedProgressBarConfig: .defaultConfig
        )
        return progressBar
    }()
 
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var actionButton: EchosButton = {
        let button = EchosButton(
            echosButtonState: .normal(
                title: EchoesString.Onboarding.Steps.buttonTitle,
            )
        )
        return button
    }()
    
    private var items: [OnboardingStep] = []
    
    // MARK: - Setup
    override func setupViews() {
        super.setupViews()
        
        addSubviews(segmentedProgressBar, scrollView, actionButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        segmentedProgressBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(4.0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(segmentedProgressBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(actionButton.snp.top)
        }
        
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8.0)
        }
    }
    
    func setupData(items: [OnboardingStep], totalSegmentsCount: Int?) {
        self.items = items
        
        var previousView: UIView? = nil
        for item in items {
            let itemView = OnboardingStepsItemView()
            itemView.setupData(item: item)
            scrollView.addSubview(itemView)
            itemView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalToSuperview()
                if let prev = previousView {
                    $0.leading.equalTo(prev.snp.trailing)
                } else {
                    $0.leading.equalToSuperview()
                }
            }
            previousView = itemView
        }
        previousView?.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        if let totalSegmentsCount {
            segmentedProgressBar.setupData(totalSegmentsCount: totalSegmentsCount)
        }
        segmentedProgressBar.highlightSegment(at: 0)
    }
    
    // MARK: - Methods
    func selectNextStep() {
        let nextPage = min(currentPageIndex + 1, items.count - 1)
        let offset = CGFloat(nextPage) * scrollView.frame.width
        scrollView.setContentOffset(.init(x: offset, y: 0), animated: true)
        segmentedProgressBar.highlightSegment(at: nextPage)
    }
    
    func onSegmentedProgressBarHighlightChanged(_ closure: @escaping (Int) -> Void) {
        self.onSegmentedProgressBarHighlightChanged = closure
    }
    
    private var currentPageIndex: Int {
        guard !scrollView.frame.width.isZero else {
            return 0
        }
        return Int(round(scrollView.contentOffset.x / scrollView.frame.width))
    }
}

// MARK: - Actions
extension OnboardingStepsView {
    func onActionButtonTap(_ closure: @escaping (Int) -> Void) {
        actionButton.onTap { [unowned self] in
            closure(self.currentPageIndex)
        }
    }
}

// MARK: - Scroll View Delegate
extension OnboardingStepsView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedProgressBar.highlightSegment(at: currentPageIndex)
        onSegmentedProgressBarHighlightChanged?(currentPageIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        segmentedProgressBar.highlightSegment(at: currentPageIndex)
        onSegmentedProgressBarHighlightChanged?(currentPageIndex)
    }
}
