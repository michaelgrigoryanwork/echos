//
//  VCFactory.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class VCFactory {
    // MARK: - Onboarding
    static func onboardingIntroViewController() -> OnboardingIntroViewController {
        let vm = OnboardingIntroViewModel()
        let vc = OnboardingIntroViewController(viewModel: vm)
        return vc
    }
    
    static func onboardingStepsViewController() -> OnboardingStepsViewController {
        let vm = OnboardingStepsViewModel()
        let vc = OnboardingStepsViewController(viewModel: vm)
        return vc
    }
}
