//
//  TrialPaywallViewModel.swift
//  Echos
//
//  Created by Emma on 10.11.25.
//

import Foundation
import ApphudSDK

final class TrialPaywallViewModel {
    @Published private(set) var selectedProduct: ApphudProduct?
    @Published private(set) var purchaseResult: ApphudPurchaseResult?
    @Published private(set) var isPurchaseInProcess: Bool = false
    @Published private(set) var purchaseError: Error?

    private var placement: ApphudPlacement?
    
    private let subscriptionHandler: SubscriptionHandlerProtocol
    
    init(
        subscriptionHandler: SubscriptionHandlerProtocol = SubscriptionHandler.shared
    ) {
        self.subscriptionHandler = subscriptionHandler
        Task {
            await getTrialProduct()
        }
    }
}

extension TrialPaywallViewModel {
    func selectProduct(_ product: ApphudProduct) {
        selectedProduct = product
    }
    
    func purchaseSubscription() {
        guard let selectedProduct else {
            return
        }
        isPurchaseInProcess = true
        Task {
            do {
                let result = try await subscriptionHandler.purchase(product: selectedProduct)
                isPurchaseInProcess = false
                if result.userCanceled {
                    return
                }
                purchaseResult = result
            } catch {
                purchaseError = error
                isPurchaseInProcess = false
            }
        }
    }
    
    func restoreSubscription() {
        isPurchaseInProcess = true
        Task {
            do {
                let result = try await subscriptionHandler.restore()
                isPurchaseInProcess = false
                if result.userCanceled {
                    return
                }
                purchaseResult = result
            } catch {
                purchaseError = error
                isPurchaseInProcess = false
            }
        }
    }
}

private extension TrialPaywallViewModel {
    func getTrialProduct() async {
        if let trialProduct = await PaywallModel.getTrialProduct() {
            selectProduct(trialProduct)
        }
    }
}
