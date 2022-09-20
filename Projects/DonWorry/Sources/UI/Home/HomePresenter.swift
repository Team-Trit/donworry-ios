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
    func formatSpaceCellViewModel(space: SpaceModels.Space) -> SpaceCellViewModel

    func formatSpaceCellListViewModel(
        spaceList: [SpaceModels.Space]
    ) -> [SpaceCellViewModel]

    func formatSection(
        isAllPaymentCompleted: Bool,
        space: SpaceModels.Space
    ) -> [BillCardSection]
}

final class HomePresenterImpl: HomePresenter {

    func formatSpaceCellViewModel(space: SpaceModels.Space) -> SpaceCellViewModel {
        return .init(
            id: space.id,
            title: space.title,
            status: convertSpaceStatus(with: space.status),
            adminID: space.adminID,
            isAllPaymentCompleted: space.isAllPaymentCompleted
        )
    }

    func formatSpaceCellListViewModel(
        spaceList: [SpaceModels.Space]
    ) -> [SpaceCellViewModel] {
        return spaceList.map { [weak self] space in
            return .init(
                id: space.id,
                title: space.title,
                status: self?.convertSpaceStatus(with: space.status) ?? .DONE,
                adminID: space.adminID,
                isAllPaymentCompleted: space.isAllPaymentCompleted
            )
        }
    }
    func formatSection(
        isAllPaymentCompleted: Bool,
        space: SpaceModels.Space
    ) -> [BillCardSection] {
        if space.payments.isEmpty { return [.BillCardSection(createOpenStateCard(status: space.status))] }
        var cards: [HomeBillCardItem] = createProgressStateCard(status: space.status)
        cards.append(contentsOf: formatBillCardList(from: space.payments, isTaker: space.isTaker))
        if isAllPaymentCompleted { cards.append(.LeaveBillCard) }
        return [.BillCardSection(cards)]
    }

    private func formatBillCardList(
        from payments: [SpaceModels.SpacePayment],
        isTaker: Bool
    ) -> [HomeBillCardItem] {
        if isTaker {
            return formatTakeBillCard(from: payments)
        } else {
            return formatGiveBillCardList(from: payments)
        }
    }

    private func createOpenStateCard(status: String) -> [HomeBillCardItem] {
        return [.StateBillCard(.init(status: convertSpaceStatusInStateBillCard(with: status)))]
    }

    private func createProgressStateCard(status: String) -> [HomeBillCardItem] {
        return [.StateBillCard(.init(status: convertSpaceStatusInStateBillCard(with: status)))
        ]
    }

    private func formatTakeBillCard(
        from payments: [SpaceModels.SpacePayment]
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
        from payments: [SpaceModels.SpacePayment]
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

    private func convertSpaceStatus(with status: String) -> SpaceCollectionViewCell.SpaceStatus {
        switch status {
        case "OPEN":
            return .OPEN
        case "PROGRESS":
            return .PROGRESS
        default:
            return .DONE
        }
    }

    private func convertSpaceStatusInStateBillCard(with status: String) -> StateBillCardCollectionViewCell.SpaceStatus {
        switch status {
        case "OPEN":
            return .OPEN
        case "PROGRESS":
            return .PROGRESS
        default:
            return .DONE
        }
    }
    
    private func formatter(_ amount: Int) -> String {
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: amount)) {
            return amountText + "원"
        }
        return "0원"
    }
}
