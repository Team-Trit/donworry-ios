//
//  ParticipatePaymentCardViewModel.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Combine
import Foundation

import BaseArchitecture
import Models

final class ParticipatePaymentCardViewModel: BaseViewModel {
    
    var cancellable = Set<AnyCancellable>()
    var paymentCards: [PaymentCard] = [.dummyPaymentCard2]
    
    @Published var checkedIDs: Set<Int> = []
    
    var numOfPaymentCards: Int {
        paymentCards.count
    }
    
    var idsOfPaymentCards: Set<Int> {
        Set(paymentCards.map{$0.id})
    }
    
    var numOfCheckedCards: Int {
        checkedIDs.count
    }
    
    func paymentCardAt(_ index: Int) -> PaymentCard {
        paymentCards[index]
    }
    
    func checkCardAt(_ id: Int) {
        if !checkedIDs.contains(id) {
            checkedIDs.update(with: id)
        } else {
            checkedIDs.remove(id)
        }
    }
    
    func isCheckedAt(_ index: Int) -> Bool {
        checkedIDs.contains(paymentCards[index].id) ? true : false
    }
    
    func resetCheck() {
        checkedIDs = []
    }
    
    func checkAll() {
        checkedIDs = idsOfPaymentCards
    }
    
}
