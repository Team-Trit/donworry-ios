//
//  PaymentCardListError.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum PaymentCardListViewError: Error {
    case cantStartAlgorithm
    case cantLeaveUntilPaymentsCompleted
    case noPaymentCardList

    var message: String {
        switch self {
        case .cantStartAlgorithm:
            return "아직 참여자가 없는 정산내역이 존재해요!"
        case .cantLeaveUntilPaymentsCompleted:
            return "정산이 완료되기 전까지 방을 나가지 못해요!"
        case .noPaymentCardList:
            return "정산 내역을 추가해주세요!"
        }
    }
}
