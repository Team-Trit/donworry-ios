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

        guard selectedPaymentRoom.transferList != nil else { return
            [.BillCardSection([.StateBillCard])] }

        var billCardItemList: [HomeBillCardItem] = []
        billCardItemList.append(.StateBillCard)
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
            var result = [HomeBillCardItem.TakeBillCard(TakeBillCardCellViewModel(filteredTransferList))]
            result.append(.LeaveBillCard)
            return result
        }
        return []
    }

    private func formatGiveBillCardList(from paymentRoom: PaymentRoom, user: User) -> [HomeBillCardItem] {
        if let transferList = paymentRoom.transferList {
            let filteredTransferList = transferList.filter { $0.giver.id == user.id }
            var result = filteredTransferList
                .map(GiveBillCardCellViewModel.init)
                .map { HomeBillCardItem.GiveBillCard($0) }
            result.append(.LeaveBillCard)
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

extension GiveBillCardCellViewModel {
    init(_ transfer: Transfer) {
        self.takerID = transfer.taker.id
        self.imageURL = transfer.taker.image
        self.nickName = transfer.taker.nickName
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: transfer.amount)) {
            self.amount = amountText + "원"
        } else {
            self.amount = "0원"
        }
        self.isCompleted = transfer.isCompleted
    }
}

extension TakeBillCardCellViewModel {
    init(_ transfers: [Transfer]) {
        self.giverID = transfers.first!.giver.id
        let completedAmount = transfers.filter { $0.isCompleted }.map { $0.amount }.reduce(0, +)
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: completedAmount)) {
            self.amount = amountText + "원"
        } else {
            self.amount = "0원"
        }
        let totalAmount =  transfers.map { $0.amount }.reduce(0, +)
        self.isCompleted =  totalAmount == completedAmount
    }
}

extension HomeHeaderViewModel {
    init(_ user: User) {
        self.nickName = user.nickName
        self.imageURL = user.image
    }
}
