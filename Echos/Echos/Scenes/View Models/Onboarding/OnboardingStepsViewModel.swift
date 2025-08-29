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
    
    func selectNextStep(completion: () -> Void)
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
            .init(position: 0, title: EchoesString.OnboardingSteps.titleOne, titleHighlight: EchoesString.OnboardingSteps.titleOneHighlight, subtitle: EchoesString.OnboardingSteps.subtitleOne, image: EchosImage.OnboardingSteps.logoOne),
            .init(position: 1, title: EchoesString.OnboardingSteps.titleTwo, titleHighlight: EchoesString.OnboardingSteps.titleTwoHighlight, subtitle: EchoesString.OnboardingSteps.subtitleTwo, image: EchosImage.OnboardingSteps.logoTwo),
            .init(position: 2, title: EchoesString.OnboardingSteps.titleThree, titleHighlight: EchoesString.OnboardingSteps.titleThreeHighlight, subtitle: EchoesString.OnboardingSteps.subtitleThree, image: EchosImage.OnboardingSteps.logoThree),
            .init(position: 3, title: EchoesString.OnboardingSteps.titleFour, titleHighlight: EchoesString.OnboardingSteps.titleFourHighlight, subtitle: EchoesString.OnboardingSteps.subtitleFour, image: EchosImage.OnboardingSteps.logoFour)
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

    func selectNextStep(completion: () -> Void) {
        selectedStepIndex += 1
        completion()
    }
}

// MARK: - Actions
extension OnboardingStepsViewModel {
    func showNextStep() {
        selectedStepIndex += 1
    }
}
