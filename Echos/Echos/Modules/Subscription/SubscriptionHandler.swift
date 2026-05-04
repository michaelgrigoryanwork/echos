//
//  SubscriptionHandler.swift
//  Echos
//
//  Created by Michael Grigoryan on 20.04.26.
//

import Foundation
import ApphudSDK

protocol SubscriptionHandlerProtocol {
    var hasPremiumAccess: Bool { get }
    
    func purchase(product: ApphudProduct) async throws -> ApphudPurchaseResult
    func restore() async throws -> ApphudPurchaseResult
    
    func prefetchPlacements() async
    func getPlacement(for placement: SubscriptionHandler.Placement) async -> ApphudPlacement?
}

final class SubscriptionHandler {
    static let shared: SubscriptionHandlerProtocol = SubscriptionHandler()

    private var placements: [Placement: ApphudPlacement] = [:]
    
    private let apphudManager: ApphudManagerProtocol

    private init(apphudManager: ApphudManager = .shared) {
        self.apphudManager = apphudManager
    }
}

extension SubscriptionHandler: SubscriptionHandlerProtocol {
    var hasPremiumAccess: Bool {
        return apphudManager.hasPremiumAccess
    }
    
    func purchase(product: ApphudProduct) async throws -> ApphudPurchaseResult {
        let result = await apphudManager.purchase(product: product)
        return try await handlePurchaseResult(result)
    }
    
    private func handlePurchaseResult(_ result: ApphudPurchaseResult) async throws -> ApphudPurchaseResult {
        let error = result.error
        if (error as? NSError)?.code == 2 {
            return result
        }
        if let subscription = result.subscription, subscription.isActive() {
            return result
        } else if let nonRenewingPurchase = result.nonRenewingPurchase, nonRenewingPurchase.isActive() {
            return result
        } else {
            throw SubscriptionError.subscriptionFailed
        }
    }
    
    func restore() async throws -> ApphudPurchaseResult {
        let result = await apphudManager.restore()
        return try await handleRestoreResult(result)
    }
    
    func handleRestoreResult(_ result: ApphudPurchaseResult?) async throws -> ApphudPurchaseResult {
        guard let result, result.subscription?.isActive() == true else {
            throw SubscriptionError.subscriptionFailed
        }
        return result
    }
    
    func prefetchPlacements() async {
        await withTaskGroup { group in
            for placementCase in Placement.allCases {
                group.addTask {
                    let placement = await self.getPlacement(for: placementCase)
                    return (placementCase, placement)
                }
            }
            for await (placementCase, placement) in group {
                if let placement = placement {
                    self.placements[placementCase] = placement
                }
            }
        }
    }
    
    func getPlacement(for placement: Placement) async -> ApphudPlacement? {
        if let existingPlacement = placements[placement] {
            return existingPlacement
        }
        return await Apphud.placement(placement.identifier)
    }
}

extension SubscriptionHandler {
    enum SubscriptionError: Error {
        case subscriptionFailed
    }
}

extension SubscriptionHandler {
    enum Placement: String, CaseIterable {
        case onboarding
        
        var identifier: String {
            return rawValue
        }
    }
}
