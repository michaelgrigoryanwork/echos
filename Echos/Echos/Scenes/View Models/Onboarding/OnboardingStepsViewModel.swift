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
            .init(position: 0, title: EchoesString.Onboarding.Steps.titleOne, titleHighlight: EchoesString.Onboarding.Steps.titleOneHighlight, subtitle: EchoesString.Onboarding.Steps.subtitleOne, image: EchosImage.Onboarding.Steps.logoOne),
            .init(position: 1, title: EchoesString.Onboarding.Steps.titleTwo, titleHighlight: EchoesString.Onboarding.Steps.titleTwoHighlight, subtitle: EchoesString.Onboarding.Steps.subtitleTwo, image: EchosImage.Onboarding.Steps.logoTwo),
            .init(position: 2, title: EchoesString.Onboarding.Steps.titleThree, titleHighlight: EchoesString.Onboarding.Steps.titleThreeHighlight, subtitle: EchoesString.Onboarding.Steps.subtitleThree, image: EchosImage.Onboarding.Steps.logoThree),
            .init(position: 3, title: EchoesString.Onboarding.Steps.titleFour, titleHighlight: EchoesString.Onboarding.Steps.titleFourHighlight, subtitle: EchoesString.Onboarding.Steps.subtitleFour, image: EchosImage.Onboarding.Steps.logoFour)
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
