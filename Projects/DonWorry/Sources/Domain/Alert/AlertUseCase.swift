//
//  AlertUseCase.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import SwiftUI
import DonWorryNetworking

public protocol AlertRepository {
    func fetchAlert()
    func deleteAllAlerts()
}

protocol AlertUseCase {
    func fetchAlerts()
    func deleteAllAlerts()
}

final class AlertUseCaseImpl: AlertUseCase {
    var alertRepository: AlertRepository
    
    init(
        _ alertRepository: AlertRepository = AlertRepositoryImpl()
    ) {
        self.alertRepository = alertRepository
    }

    
    func fetchAlerts() {
        
    }
    
    func deleteAllAlerts() {
    
    }
}
