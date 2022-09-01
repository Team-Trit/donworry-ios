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
        spaceList: [Entity.Space],
        selectedIndex: Int
    ) -> [PaymentRoomCellViewModel]

    func formatSection(
        payments: [Entity.SpacePayment],
        isTaker: Bool
    ) -> [BillCardSection]
}

final class HomePresenterImpl: HomePresenter {

    func formatSection(
        spaceList: [Entity.Space],
        selectedIndex: Int
    ) -> [PaymentRoomCellViewModel] {
        return spaceList.enumerated().map {
            .init(title: $0.element.title, isSelected: $0.offset == selectedIndex)
        }
    }
    func formatSection(
        payments: [Entity.SpacePayment],
        isTaker: Bool
    ) -> [BillCardSection] {
        if payments.isEmpty { return [.BillCardSection([.StateBillCard])] }
        var cards = formatBillCardList(from: payments, isTaker: isTaker)
        cards.append(.LeaveBillCard)
        return [.BillCardSection(cards)]
    }

    private func formatBillCardList(from payments: [Entity.SpacePayment], isTaker: Bool) -> [HomeBillCardItem] {
        if isTaker {
            return formatGiveBillCardList(from: payments, isTaker: isTaker)
        } else {
            return formatTakeBillCard(from: payments, isTaker: isTaker)
        }
    }

    private func formatTakeBillCard(from payments: [Entity.SpacePayment], isTaker: Bool) -> [HomeBillCardItem] {
        let completedAmount = payments.filter { $0.isCompleted }.map { $0.amount }.reduce(0, +)
        let totalAmount = payments.map { $0.amount }.reduce(0, +)
        return [HomeBillCardItem.TakeBillCard(
            .init(amount: formatter(completedAmount), isCompleted: totalAmount == completedAmount)
        )]
    }

    private func formatGiveBillCardList(from payments: [Entity.SpacePayment], isTaker: Bool) -> [HomeBillCardItem] {
        return payments.compactMap { [weak self] in
            self?.convertToGiveCellModel(from: $0)
        }.map { HomeBillCardItem.GiveBillCard($0)}
    }

    private func convertToGiveCellModel(from payment: Entity.SpacePayment) -> GiveBillCardCellViewModel {
        return .init(takerID: payment.user.id, imageURL: payment.user.imgURL, nickName: payment.user.nickname, amount: formatter(payment.amount), isCompleted: payment.isCompleted)
    }
    
    private func formatter(_ amount: Int) -> String {
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: amount)) {
            return amountText + "원"
        }
        return "0원"
    }
}
