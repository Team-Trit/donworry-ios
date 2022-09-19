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
    func formatSpaceCellViewModel(
        spaceList: [SpaceModels.Space],
        selectedIndex: Int
    ) -> [SpaceCellViewModel]

    func formatSection(
        isAllPaymentCompleted: Bool,
        payments: [SpaceModels.SpacePayment],
        isTaker: Bool
    ) -> [BillCardSection]
}

final class HomePresenterImpl: HomePresenter {

    func formatSpaceCellViewModel(
        spaceList: [SpaceModels.Space],
        selectedIndex: Int
    ) -> [SpaceCellViewModel] {
        return spaceList.map {
            return .init(title: $0.title)
        }
    }
    func formatSection(
        isAllPaymentCompleted: Bool,
        payments: [SpaceModels.SpacePayment],
        isTaker: Bool
    ) -> [BillCardSection] {
        if payments.isEmpty { return [.BillCardSection(createOpenStateCard())] }
        var cards: [HomeBillCardItem] = createProgressStateCard(by: isAllPaymentCompleted)
        cards.append(contentsOf: formatBillCardList(from: payments, isTaker: isTaker))
        if isAllPaymentCompleted { cards.append(.LeaveBillCard) } 
        return [.BillCardSection(cards)]
    }

    private func formatBillCardList(
        from payments: [SpaceModels.SpacePayment],
        isTaker: Bool
    ) -> [HomeBillCardItem] {
        if isTaker {
            return formatTakeBillCard(from: payments, isTaker: isTaker)
        } else {
            return formatGiveBillCardList(from: payments, isTaker: isTaker)
        }
    }

    private func createOpenStateCard() -> [HomeBillCardItem] {
        return [.StateBillCard(.init(status: .open))]
    }

    private func createProgressStateCard(by isAllPaymentCompleted: Bool) -> [HomeBillCardItem] {
        return [.StateBillCard(.init(status: isAllPaymentCompleted ? .done : .progress))]
    }

    private func formatTakeBillCard(
        from payments: [SpaceModels.SpacePayment],
        isTaker: Bool
    ) -> [HomeBillCardItem] {
        let completedAmount = payments.filter { $0.isCompleted }.map { $0.amount }.reduce(0, +)
        let totalAmount = payments.map { $0.amount }.reduce(0, +)
        return [HomeBillCardItem.TakeBillCard(
            .init(
                userCount: payments.filter { !$0.isCompleted }.count,
                totalCount: payments.count,
                amount: formatter(completedAmount),
                isCompleted: totalAmount == completedAmount
            )
        )]
    }

    private func formatGiveBillCardList(
        from payments: [SpaceModels.SpacePayment],
        isTaker: Bool
    ) -> [HomeBillCardItem] {
        return payments.compactMap { [weak self] in
            self?.convertToGiveCellModel(from: $0)
        }.map { HomeBillCardItem.GiveBillCard($0)}
    }

    private func convertToGiveCellModel(
        from payment: SpaceModels.SpacePayment
    ) -> GiveBillCardCellViewModel {
        return .init(id: payment.id, takerID: payment.user.id, imageURL: payment.user.imgURL, nickName: payment.user.nickname, amount: formatter(payment.amount), isCompleted: payment.isCompleted)
    }
    
    private func formatter(_ amount: Int) -> String {
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: amount)) {
            return amountText + "원"
        }
        return "0원"
    }
}
