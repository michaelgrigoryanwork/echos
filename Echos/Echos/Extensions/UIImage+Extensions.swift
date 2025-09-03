//
//  UIImage+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import UIKit

struct EchosImage {
    struct Main {
        // MARK: - Properties
        static let navigationBack = UIImage(named: "Main.navigationBack")
    }
    
    struct Onboarding{
        // MARK: - Properties
        static let logo = UIImage(named: "Onboarding.logo")
        
        struct Steps {
            // MARK: - Properties
            static let logoOne = UIImage(named: "OnboardingSteps.logoOne")
            static let logoTwo = UIImage(named: "OnboardingSteps.logoTwo")
            static let logoThree = UIImage(named: "OnboardingSteps.logoThree")
            static let logoFour = UIImage(named: "OnboardingSteps.logoFour")
        }
    }
    
    struct Authorization {
        // MARK: - Properties
        static let appleIcon = UIImage(named: "Authorization.appleIcon")
        static let googleIcon = UIImage(named: "Authorization.googleIcon")
    }
}
