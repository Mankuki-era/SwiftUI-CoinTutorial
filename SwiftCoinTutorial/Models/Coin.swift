//
//  Coin.swift
//  SwiftCoinTutorial
//
//  Created by Mankuki_era on 2023/08/01.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int
    let priceChange24H, priceChangePercentage24H: Double

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}

extension Coin {
    
    static var sample = Coin (
        id: "Bitcoin",
        symbol: "BTC",
        name: "Bitcoin",
        image: "",
        currentPrice: 16700,
        marketCapRank: 1,
        priceChange24H: 200,
        priceChangePercentage24H: 2.0
    )
    
}
