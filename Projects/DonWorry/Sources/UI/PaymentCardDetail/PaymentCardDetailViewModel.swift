//
//  PaymentCardDetailViewModel.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/30.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Combine

import BaseArchitecture
import Models
import UIKit

class PaymentCardDetailViewModel:BaseViewModel {
    
    typealias cardResponse = PaymentCardModels.FetchCard.Response
    var cancellable = Set<AnyCancellable>()
    //TODO: payer 가져오기
    let payer: User = User.dummyUser1
    @Published var paymentCard: cardResponse.PaymentCard = .init(id: -1, totalAmount: 0, users: [], imgUrls: [])
    
    var paymentUseCase: PaymentCardServiceImpl = PaymentCardServiceImpl()
    var userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    
    init(cardID: Int, cardName: String) {
        self.paymentCardName = cardName
        super.init()
        paymentUseCase.fetchPaymentCard(cardId: cardID)
            .subscribe(onNext: { [weak self] response in
                self?.paymentCard = response.card
            }).disposed(by: disposeBag)
        
    }
    
    var isAttended: Bool = false
    
    var participatedUserList: [User] {
        paymentCard.users.map {
            .init(id: $0.id, nickName: $0.nickname, bankAccount: .empty, image: $0.imgURL ?? "")
        }
    }
    
    var numOfUsers: Int {
        paymentCard.users.count
    }
    
    var totalAmountString: String {
        return paymentCard.totalAmount.formatted() + "원"
    }
    
    var isAdmin: Bool {
        guard let userID = userAccountRepository.fetchLocalUserAccount()?.id else { return false }
        return userID == paymentCard.users.filter{$0.isTaker}.first?.id
    }
    
    var numOfFilesWhenNoImages: Int {
        isAdmin ? 1 : 0
    }
  
    var paymentCardName: String
    
    func userCollectionViewAt(_ index: Int) -> User {
        let user = paymentCard.users[index]
        return User(id: user.id, nickName: user.nickname, bankAccount: .empty, image: user.imgURL ?? "")
    }
   
    func toggleAttendance() {
        self.isAttended.toggle()
        paymentUseCase.joinPaymentCardList(ids: [paymentCard.id])
            .subscribe(onNext: { str in
                print(str)
            }).disposed(by: disposeBag)
    }
    
    func deletePaymentCard() {
        paymentUseCase.DeletePaymentCardList(cardId: paymentCard.id)
            .subscribe(onNext: { str in
                print(str)
            }).disposed(by: disposeBag)
    }
    
}
