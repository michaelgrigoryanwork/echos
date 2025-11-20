//
//  HomeScreenViewController.swift
//  Echos
//
//  Created by Emma on 18.11.25.
//

import UIKit

final class ContentViewController: UIViewController {
    private let contentView: UIView

    init(contentView: UIView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }
}

final class HomeScreenViewController: BaseViewController {

    // MARK: - Types

    enum Category: Int, CaseIterable {
        case phraseOfTheDay = 0
        case meditation
        case stats
    }

    // MARK: - UI

    private lazy var categoryButtons: [UIButton] = [
        makeCategoryButton(title: "home.category.phrase_of_the_day".localized(), tag: Category.phraseOfTheDay.rawValue),
        makeCategoryButton(title: "home.category.meditation".localized(), tag: Category.meditation.rawValue),
        makeCategoryButton(title: "home.category.stats".localized(), tag: Category.stats.rawValue)
    ]

    private lazy var categoriesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: categoryButtons)
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    private let homeScreenPhraseView = HomeScreenPhraseView()
    private let homeScreenMeditationView = HomeScreenMeditationView()
    private let homeScreenStatsView = HomeScreenStatsView()

    
    private lazy var pages: [UIViewController] = [
        ContentViewController(contentView: homeScreenPhraseView),
        ContentViewController(contentView: homeScreenMeditationView),
        ContentViewController(contentView: homeScreenStatsView)
    ]

    // MARK: - Properties

    private let viewModel: HomeScreenViewModel

    private var currentIndex: Int = 0 {
        didSet {
            selectedCategory = Category(rawValue: currentIndex) ?? .phraseOfTheDay
        }
    }

    private var selectedCategory: Category = .phraseOfTheDay {
        didSet {
            updateCategorySelectionUI()
        }
    }

    // MARK: - Init

    init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setupNavigationView()
        setupLayout()
        setupPageViewController()
        updateCategorySelectionUI()
        setupClosure()
    }

    // MARK: - Setup

    private func setupNavigationView() {
        setNavigationTitle(
            "home_screen_navigation_title".localized(),
            font: EchosFont.helveticaMedium(size: 18).uiFont
        )
    }
    
    private func setupClosure() {
        homeScreenPhraseView.configure(messengers: [.appMessenger, .vk, .telegram, .whatsapp])
        
        homeScreenPhraseView.onMessengerTap = { [weak self] type in
            guard let self else { return }
//            switch type {
//            case .appMessenger:
//                
//            case .vk:
//                
//            case .telegram:
//                
//            case .whatsapp:
//                
//            }
        }
        homeScreenMeditationView.onMeditationSelected = { [weak self]  meditationType in
            guard let self else { return }
            let vc = VCFactory.playerViewController()
            push(vc)
        }
    }

    private func makeCategoryButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = EchosFont.helveticaRegular(size: 14).uiFont

        button.layer.borderWidth = 1
        button.layer.cornerRadius = 18
        button.backgroundColor = .white

        button.setTitleColor(.echosBlack30, for: .normal)
        button.setTitleColor(.homeScreenButton, for: .selected)
        button.layer.borderColor = UIColor.echosBlack30.cgColor

        button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
        return button
    }

    private func setupLayout() {
        view.addSubview(categoriesStackView)
        view.addSubview(pageViewController.view)

        categoriesStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(36)
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(categoriesStackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        pageViewController.setViewControllers(
            [pages[currentIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }

    // MARK: - Selection UI
    
    private func selectionColor(for category: Category) -> UIColor {
        switch category {
        case .phraseOfTheDay:
            return .homeScreenButton
        case .meditation:
            return .echoMeditationSelectionBlue
        case .stats:
            return .echoStatisticsSelectionPink
        }
    }

    private func updateCategorySelectionUI() {
        for button in categoryButtons {
            guard let category = Category(rawValue: button.tag) else { continue }

            let isSelected = category == selectedCategory
            button.isSelected = isSelected

            if isSelected {
                let color = selectionColor(for: category)
                button.layer.borderColor = color.cgColor
                button.setTitleColor(color, for: .selected)
            } else {
                button.layer.borderColor = UIColor.echosBlack30.cgColor
                button.setTitleColor(.echosBlack30, for: .normal)
            }
        }
    }

    private func goToCategory(_ category: Category, animated: Bool) {
        let newIndex = category.rawValue
        guard newIndex >= 0, newIndex < pages.count else { return }

        let direction: UIPageViewController.NavigationDirection =
            newIndex > currentIndex ? .forward : .reverse

        currentIndex = newIndex

        pageViewController.setViewControllers(
            [pages[newIndex]],
            direction: direction,
            animated: animated,
            completion: nil
        )
    }

    // MARK: - Actions

    @objc private func categoryTapped(_ sender: UIButton) {
        guard let category = Category(rawValue: sender.tag) else { return }
        goToCategory(category, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource & Delegate

extension HomeScreenViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let visible = pageViewController.viewControllers?.first,
              let index = pages.firstIndex(of: visible) else { return }

        currentIndex = index           
    }
}
