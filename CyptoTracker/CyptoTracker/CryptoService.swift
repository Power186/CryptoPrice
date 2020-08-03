//
//  CryptoService.swift
//  CyptoTracker
//
//  Created by Scott on 8/3/20.
//  Copyright © 2020 Scott. All rights reserved.
//  URL: https://api.coinranking.com/v1/public/coins

import Foundation
import Combine

final class CryptoService {
    
    var components: URLComponents {
        var compenents = URLComponents()
        compenents.scheme = "https"
        compenents.host = "api.coinranking.com"
        compenents.path = "/v1/public/coins"
        compenents.queryItems = [URLQueryItem(name: "base", value: "USD"), URLQueryItem(name: "timePeriod", value: "24h")]
        return compenents
    }
    
    func fetchCoins() -> AnyPublisher<CryptoDataContainer, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map { $0.data }
            .decode(type: CryptoDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct CryptoDataContainer: Decodable {
    
    let status: String
    let data: CryptoData
}

struct CryptoData: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable, Hashable {
    
    let name: String
    let price: String
}
