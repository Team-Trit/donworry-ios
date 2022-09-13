//
//  ParticipatePaymentCardViewModel.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Combine
import Foundation
import RxSwift
import BaseArchitecture
import Models
import DonWorryNetworking

final class ParticipatePaymentCardViewModel: BaseViewModel {
    
    typealias Space = PaymentCardModels.FetchCardList.Response
    var paymentUseCase: PaymentCardServiceImpl = PaymentCardServiceImpl()
    
    init(spaceID: Int) {
        super.init()
        paymentUseCase.fetchPaymentCardList(spaceID: spaceID)
            .subscribe(onNext: { [weak self] cards in
                self?.paymentCards = cards.cards
            }).disposed(by: disposeBag)
    }
    
    var cancellable = Set<AnyCancellable>()
    
    @Published var checkedIDs: Set<Int> = []
    @Published var paymentCards: [Space.PaymentCard] = []
    
    var numOfPaymentCards: Int {
        paymentCards.count
    }
    
    var idsOfPaymentCards: Set<Int> {
        Set(paymentCards.map{$0.id})
    }
    
    var numOfCheckedCards: Int {
        checkedIDs.count
    }
    
    func paymentCardAt(_ index: Int) -> Space.PaymentCard {
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
    
    func checkAttendance() {
//        paymentUseCase.joinPaymentCardList(ids: Array(checkedIDs))
//            .subscribe(onNext: { str in
//                print(str)
//            }).disposed(by: disposeBag)
    }
    
}
