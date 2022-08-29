//
//  ParticipatePaymentCardViewModel.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import BaseArchitecture
import Combine

class ParticipatePaymentCardViewModel: BaseViewModel {
    
    var cancellable = Set<AnyCancellable>()
    var paymentCards: [PaymentCard] = [.dummyPaymentCard1, .dummyPaymentCard2]
    
    @Published var checkedIDs: Set<String> = []
    
    var numOfPaymentCards: Int {
        paymentCards.count
    }
    
    var idsOfPaymentCards: Set<String> {
        Set(paymentCards.map{$0.id})
    }
    
    func paymentCardAt(_ index: Int) -> PaymentCard {
        paymentCards[index]
    }
    
    var numOfCheckedCards: Int {
        checkedIDs.count
    }
    
    func checkCardAt(_ id: String) {
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
