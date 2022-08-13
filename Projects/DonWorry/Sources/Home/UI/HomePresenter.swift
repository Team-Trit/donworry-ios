//
//  HomePresenter.swift
//  DonWorry
//
//  Created by Woody on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import DonWorryExtensions

protocol HomePresenter {
    func formatSection(
        from paymentRoomList: [PaymentRoom],
        with selectedIndex: Int,
        user: User
    ) -> [BillCardSection]

    func formHomeHeader(
        from user: User
    ) -> HomeHeaderViewModel
}

final class HomePresenterImpl: HomePresenter {

    func formHomeHeader(
        from user: User
    ) -> HomeHeaderViewModel {
        return HomeHeaderViewModel(imageURL: user.image, nickName: user.nickName)
    }

    func formatSection(
        from paymentRoomList: [PaymentRoom],
        with selectedIndex: Int,
        user: User
    ) -> [BillCardSection] {
        if paymentRoomList.isEmpty { return [.BillCardSection([])] }
        let selectedPaymentRoom: PaymentRoom = paymentRoomList[selectedIndex]

        guard selectedPaymentRoom.transferList != nil else { return [.BillCardSection([.StatePaymentCard])] }

        var billCardItemList: [HomeBillCardItem] = []
        billCardItemList.append(.StatePaymentCard)
        billCardItemList.append(contentsOf: formatBillCardList(from: selectedPaymentRoom, user: user))
        return [.BillCardSection(billCardItemList)]
    }

    private func formatBillCardList(from paymentRoom: PaymentRoom, user: User) -> [HomeBillCardItem] {
        switch judgeGiveOrTakeBillCard(from: paymentRoom, user: user) {
        case .give: return formatGiveBillCardList(from: paymentRoom, user: user)
        case .take: return formatTakeBillCard(from: paymentRoom, user: user)
        case .none: return []
        }
    }

    private func formatTakeBillCard(from paymentRoom: PaymentRoom, user: User) -> [HomeBillCardItem] {
        if let transferList = paymentRoom.transferList {
            let filteredTransferList = transferList.filter { $0.taker.id == user.id }
            var result = [HomeBillCardItem.TakePaymentCard(TakePaymentCardCellViewModel(filteredTransferList))]
            result.append(.LeavePaymentCard)
            return result
        }
        return []
    }

    private func formatGiveBillCardList(from paymentRoom: PaymentRoom, user: User) -> [HomeBillCardItem] {
        if let transferList = paymentRoom.transferList {
            let filteredTransferList = transferList.filter { $0.giver.id == user.id }
            var result = filteredTransferList
                .map(GivePaymentCardCellViewModel.init)
                .map { HomeBillCardItem.GivePaymentCard($0) }
            if isAllBillCardListCompleted(filteredTransferList) {
                result.append(.LeavePaymentCard)
            }
            return result
        }
        return []
    }

    private func judgeGiveOrTakeBillCard(from paymentRoom: PaymentRoom, user: User) -> BillCardType? {
        if let transfer = paymentRoom.transferList,
           let firstTransfer = transfer.first {
            return firstTransfer.giver.id == user.id ? .give : .take
        }
        return nil
    }

    private func isAllBillCardListCompleted(_ transferList: [Transfer]) -> Bool {
        return transferList.filter({ $0.isCompleted }).count == transferList.count
    }

    private enum BillCardType {
        case give
        case take
    }
}

extension GivePaymentCardCellViewModel {
    init(_ transfer: Transfer) {
        self.takerID = transfer.taker.id
        self.imageURL = transfer.taker.image
        self.nickName = transfer.taker.nickName
        self.amount = transfer.amount
        self.isComplete = transfer.isCompleted
    }
}

extension TakePaymentCardCellViewModel {
    init(_ transfers: [Transfer]) {
        self.giverID = transfers.first!.giver.id
        self.amount = transfers.filter { $0.isCompleted }.map { $0.amount }.reduce(0, +)
        self.wholeAmount =  transfers.map { $0.amount }.reduce(0, +)
    }
}

extension HomeHeaderViewModel {
    init(_ user: User) {
        self.nickName = user.nickName
        self.imageURL = user.image
    }
}
