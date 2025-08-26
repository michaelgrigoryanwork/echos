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
    struct OnboardingIntro {
        static let title = "OnboardingIntro.title".localized()
        static let titleHighlight = "OnboardingIntro.titleHighight".localized()
        static let subtitle = "OnboardingIntro.subtitle".localized()
        static let buttonTitle = "OnboardingIntro.buttonTitle".localized()
    }
    
    struct OnboardingSteps {
        static let titleOne = "OnboardingSteps.titleOne".localized()
        static let titleOneHighlight = "OnboardingSteps.titleOneHighlight".localized()
        static let subtitleOne = "OnboardingSteps.subtitleOne".localized()
        static let buttonTitle = "OnboardingSteps.buttonTitle".localized()
    }
}
