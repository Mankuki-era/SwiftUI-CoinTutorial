//
//  HomeViewModel.swift
//  SwiftCoinTutorial
//
//  Created by Mankuki_era on 2023/08/01.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var topMovingCoins = [Coin]()
    @Published var error: Error?
    
    private var pageLimit = 20
    private var page = 0
    
    let BASE_URL = "https://api.coingecko.com/api/v3/coins/"
    
    var urlString: String {
        return "\(BASE_URL)markets?vs_currency=usd&order=market_cap_desc&per_page=\(pageLimit)&page=\(page)&price_change_percentage=24h&locale=en"
    }
    
    init() {
//        fetchCoinData()
        loadData()
    }
    
    func handleRefresh() {
        coins.removeAll()
        page = 0
        loadData()
    }
}

// MARK: - Async/Await

extension HomeViewModel {
    @MainActor
    func fetchCoinsAsync() async throws {
        do {
            page += 1
            guard let url = URL(string: urlString) else { throw CoinError.invalidURL }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw CoinError.serverError }
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else { throw CoinError.invalidData }
            self.coins.append(contentsOf: coins)
        } catch {
            self.error = error
        }
        
    }
    
    func loadData() {
        Task(priority: .medium) {
            try await fetchCoinsAsync()
        }
    }
}

// MARK: - DispatchQue
extension HomeViewModel {
    func fetchCoinData() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Error \(error)")
                    return
                }
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    self.error = CoinError.serverError
                    return
                }
                
                guard let data = data else {
                    print("DEBUG: Invalid data")
                    return
                }
                
                guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                    print("DEBUG: Invalid data")
                    return
                }
                
                self.coins = coins
                self.configureTopMovingCoins()
            }
            
        }.resume()
    }
    
    func configureTopMovingCoins() {
        let topMovers = coins.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
        self.topMovingCoins = Array(topMovers.prefix(5))
    }
}
