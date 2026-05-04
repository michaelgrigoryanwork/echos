//
//  PaywallModel.swift
//  Echos
//
//  Created by Michael Grigoryan on 04.05.26.
//

import Foundation
import ApphudSDK
import StoreKit

protocol PaywallModelProtocol {
    var products: [ApphudProduct]? { get }
}

final class PaywallModel {
    private let placement: ApphudPlacement?
    
    init?(placement: ApphudPlacement?) {
        guard let placement else {
            return nil
        }
        self.placement = placement
    }
}

extension PaywallModel: PaywallModelProtocol {
    private var paywall: ApphudPaywall? {
        return placement?.paywall
    }
    
    var products: [ApphudProduct]? {
        guard let paywall else {
            return nil
        }
        return paywall.products
    }
}

extension PaywallModel {
    static func getSubscriptionDisplayName(product: Product) -> String? {
        switch product.subscription?.subscriptionPeriod {
        case .yearly:
            return "Paywall.annual".localized()
        case .monthly:
            return "Paywall.monthly".localized()
        default:
            if product.type == .nonConsumable {
                return "Paywall.lifetime".localized() // Lifetime
            }
            return nil
        }
    }
    
    static func getSubscriptionDisplayPrice(product: Product) -> String? {
        switch product.subscription?.subscriptionPeriod {
        case .yearly:
            return "\(product.displayPrice)/\("Paywall.yearly".localized())"
        case .monthly:
            return "\(product.displayPrice)/\("Paywall.month".localized())"
        default:
            if product.type == .nonConsumable {
                return product.displayPrice // Lifetime
            }
            return product.displayPrice
        }
    }
    
    static func getSubscriptionDisplayPriceForWeek( product: Product) -> String? {
        guard let weeklyDisplayPrice = product.weeklyDisplayPrice else {
            return nil
        }
        return "\(weeklyDisplayPrice)/\("Paywall.week".localized())"
    }
    
    static func isIntroAvailable(product: SKProduct) async -> Bool {
        let isIntroAvailable: Bool = await withCheckedContinuation { continuation in
            Apphud.checkEligibilityForIntroductoryOffer(product: product) { available in
                continuation.resume(returning: available)
            }
        }
        return isIntroAvailable
    }
}

private extension Product {
    var weeklyDisplayPrice: String? {
        guard let subscriptionInfo = self.subscription else {
            return nil
        }
        
        let period = subscriptionInfo.subscriptionPeriod
        let price = self.price // This is already a Decimal in SK2
        var weeklyPrice: Decimal = 0
        
        switch period.unit {
        case .year:
            let totalWeeks = Decimal(period.value * 52)
            weeklyPrice = price / totalWeeks
            
        case .month:
            let totalMonths = Decimal(period.value)
            let weeksInMonth: Decimal = 52.0 / 12.0
            let totalWeeks = totalMonths * weeksInMonth
            weeklyPrice = price / totalWeeks
            
        case .week:
            let totalWeeks = Decimal(period.value)
            weeklyPrice = price / totalWeeks
            
        case .day:
            let totalWeeks = Decimal(period.value) / 7.0
            weeklyPrice = price / totalWeeks
            
        @unknown default:
            return nil
        }
        
        return weeklyPrice.formatted(self.priceFormatStyle)
    }
}
