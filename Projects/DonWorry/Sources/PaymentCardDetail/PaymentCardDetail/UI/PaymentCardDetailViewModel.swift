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
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let amountString = numberFormatter.string(from: NSNumber(value: paymentCard.totalAmount)) ?? ""
        return amountString + "원"
    }
    
    var isAdmin: Bool {
        payer.id == paymentCard.payer.id
    }
    
    var numOfFilesWhenImage0: Int {
        isAdmin ? 1 : 0
    }
  
    func userAt(_ index: Int) -> User {
        paymentCard.participatedUserList[index]
    }
   
    func toggleAttendance() {
        self.isAttended.toggle()
    }
    
}
