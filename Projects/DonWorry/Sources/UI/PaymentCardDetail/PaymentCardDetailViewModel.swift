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

class PaymentCardDetailViewModel {
    
    var cancellable = Set<AnyCancellable>()
    let payer: User = User.dummyUser1
    let paymentCard = PaymentCard.dummyPaymentCard1
    
    var isAttended: Bool = false
    
    var participatedUserList: [User] {
        paymentCard.participatedUserList
    }
    
    var numOfUsers: Int {
        paymentCard.participatedUserList.count
    }
    
    var totalAmountString: String {
        return paymentCard.totalAmount.formatted() + "원"
    }
    
    var isAdmin: Bool {
        payer.id == paymentCard.payer.id
    }
    
    var numOfFilesWhenNoImages: Int {
        isAdmin ? 1 : 0
    }
  
    func userCollectionViewAt(_ index: Int) -> User {
        paymentCard.participatedUserList[index]
    }
   
    func toggleAttendance() {
        self.isAttended.toggle()
    }
    
}
