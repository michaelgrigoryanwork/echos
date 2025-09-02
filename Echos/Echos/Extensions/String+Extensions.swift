//
//  String+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

extension String {
    // MARK: - Methods
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

struct EchoesString {
    struct Onboarding {
        struct Intro {
            // MARK: - Properties
            static let title = "OnboardingIntro.title".localized()
            static let titleHighlight = "OnboardingIntro.titleHighight".localized()
            static let subtitle = "OnboardingIntro.subtitle".localized()
            static let buttonTitle = "OnboardingIntro.buttonTitle".localized()
        }
        
        struct Steps {
            // MARK: - Properties
            static let titleOne = "OnboardingSteps.titleOne".localized()
            static let titleOneHighlight = "OnboardingSteps.titleOneHighlight".localized()
            static let subtitleOne = "OnboardingSteps.subtitleOne".localized()
            static let titleTwo = "OnboardingSteps.titleTwo".localized()
            static let titleTwoHighlight = "OnboardingSteps.titleTwoHighlight".localized()
            static let subtitleTwo = "OnboardingSteps.subtitleTwo".localized()
            static let titleThree = "OnboardingSteps.titleThree".localized()
            static let titleThreeHighlight = "OnboardingSteps.titleThreeHighlight".localized()
            static let subtitleThree = "OnboardingSteps.subtitleThree".localized()
            static let titleFour = "OnboardingSteps.titleFour".localized()
            static let titleFourHighlight = "OnboardingSteps.titleFourHighlight".localized()
            static let subtitleFour = "OnboardingSteps.subtitleFour".localized()
            static let buttonTitle = "OnboardingSteps.buttonTitle".localized()
        }
        
        struct Loading {
            // MARK: - Properties
            static let title = "OnboardingLoading.title".localized()
            static let subtitle = "OnboardingLoading.subtitle".localized()
        }
    }
}
