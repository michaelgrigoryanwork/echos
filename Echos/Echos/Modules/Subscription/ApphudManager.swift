//
//  ApphudManager.swift
//  Echos
//
//  Created by Michael Grigoryan on 20.04.26.
//

import Foundation
import ApphudSDK

protocol ApphudManagerProtocol {
    var hasPremiumAccess: Bool { get }
    
    func start() async
    
    func purchase(product: ApphudProduct) async -> ApphudPurchaseResult
    func restore() async -> ApphudPurchaseResult?
}

final class ApphudManager {
    static let shared = ApphudManager()
    
    private(set) var userId: String?
    
    private init(userId: String? = nil) {
        self.userId = userId
    }
}

extension ApphudManager: ApphudManagerProtocol, ApphudDelegate, ApphudUIDelegate {
    func start() async {
        Apphud.setDelegate(self)
        Apphud.setUIDelegate(self)
        await Apphud.start(apiKey: "app_tjscncinDyvZMHkTjvR8X8SvJj9M43")
        userId = await Apphud.userID()
    }
    
    var hasPremiumAccess: Bool {
        return Apphud.hasPremiumAccess()
    }

    func apphudShouldShowScreen(screenName: String) -> Bool {
        return false
    }
    
    func purchase(product: ApphudProduct) async -> ApphudPurchaseResult {
        return await Apphud.purchase(product)
    }
    
    func restore() async -> ApphudPurchaseResult? {
        return await Apphud.restorePurchases()
    }
}
