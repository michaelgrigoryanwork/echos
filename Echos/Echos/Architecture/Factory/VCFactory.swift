//
//  VCFactory.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

final class VCFactory {
    // MARK: - Onboarding
    static func onboardingIntro() -> OnboardingIntroViewController {
        let vm = OnboardingIntroViewModel()
        let vc = OnboardingIntroViewController(viewModel: vm)
        return vc
    }
    
    static func onboardingSteps() -> OnboardingStepsViewController {
        let vm = OnboardingStepsViewModel()
        let vc = OnboardingStepsViewController(viewModel: vm)
        return vc
    }
    
    static func onboardingLoading() -> OnboardingLoadingViewController {
        let vm = OnboardingLoadingViewModel()
        let vc = OnboardingLoadingViewController(viewModel: vm)
        return vc
    }
    
    // MARK: - Auth
    static func authorization() -> AuthorizationViewController {
        let vm = AuthorizationViewModel()
        let vc = AuthorizationViewController(viewModel: vm)
        return vc
    }
    
    //MARK: - Paywall
    static func paywallViewController() -> PaywallViewController {
        let vm = PaywallViewModel()
        let vc = PaywallViewController(viewModel: vm)
        return vc
    }
    
    static func paywallPlansViewController() -> PaywallPlansViewController {
        let vm = PaywallPlansViewModel()
        let vc = PaywallPlansViewController(viewModel: vm)
        return vc
    }
}
