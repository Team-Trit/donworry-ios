//
//  AlertRepositoryImpl.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import Models

// repo : 서버에서 바로가져옴
final class AlertRepositoryImpl: AlertRepository {
    private let network: NetworkServable
    
    init(network: NetworkServable = NetworkService()) {
        self.network = network
    }
    
    func fetchAlert() {
        // fetch data
    }
    
    func deleteAllAlerts() {
      //    delet Api
    }
    
}
