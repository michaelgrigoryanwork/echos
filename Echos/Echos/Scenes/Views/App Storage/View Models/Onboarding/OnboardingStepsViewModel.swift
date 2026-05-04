//
//  OnboardingStepsViewModel.swift
//  Echos
//
//  Created by Michael Grigoryan on 26.08.25.
//

import Foundation

protocol OnboardingStepsViewModelProtocol {
    // MARK: - Properties
    var isLastStep: Bool { get }
    
    // MARK: - Methods
    func getSteps() -> [OnboardingStep]
    func getCurrentStep() -> OnboardingStep?
    func getStep(at index: Int) -> OnboardingStep?
    
    func selectStep(index: Int, completion: (() -> Void)?)
}

extension OnboardingStepsViewModelProtocol {
    // MARK: - Methods
    func selectStep(index: Int, completion: (() -> Void)? = nil) {
        selectStep(index: index, completion: completion)
    }
}

final class OnboardingStepsViewModel {
    // MARK: - Properties
    var isLastStep: Bool {
        return selectedStepIndex == steps.count - 1
    }
    
    let steps: [OnboardingStep]
    
    private var selectedStepIndex = 0
    
    // MARK: - Init
    init() {
        steps = [
            .init(position: 0, title: EchosString.Onboarding.Steps.titleOne, titleHighlight: EchosString.Onboarding.Steps.titleOneHighlight, subtitle: EchosString.Onboarding.Steps.subtitleOne, animationName: "2_onboarding"),
            .init(position: 1, title: EchosString.Onboarding.Steps.titleTwo, titleHighlight: EchosString.Onboarding.Steps.titleTwoHighlight, subtitle: EchosString.Onboarding.Steps.subtitleTwo,animationName: "3_onboarding"),
            .init(position: 2, title: EchosString.Onboarding.Steps.titleThree, titleHighlight: EchosString.Onboarding.Steps.titleThreeHighlight, subtitle: EchosString.Onboarding.Steps.subtitleThree, animationName: "4_onboarding"),
            .init(position: 3, title: EchosString.Onboarding.Steps.titleFour, titleHighlight: EchosString.Onboarding.Steps.titleFourHighlight, subtitle: EchosString.Onboarding.Steps.subtitleFour, animationName: "5_onboarding")
        ]
    }
}

// MARK: - Protocol
extension OnboardingStepsViewModel: OnboardingStepsViewModelProtocol {
    func getSteps() -> [OnboardingStep] {
        return steps
    }
    
    func getCurrentStep() -> OnboardingStep? {
        return steps[safe: selectedStepIndex]
    }
    
    func getStep(at index: Int) -> OnboardingStep? {
        return steps[safe: index]
    }

    func selectStep(index: Int, completion: (() -> Void)? = nil) {
        selectedStepIndex = index
        completion?()
    }
}

// MARK: - Actions
extension OnboardingStepsViewModel {
    func showNextStep() {
        selectedStepIndex += 1
    }
}
