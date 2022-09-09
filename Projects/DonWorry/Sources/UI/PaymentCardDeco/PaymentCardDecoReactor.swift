//
//  PaymentCardDecoReactor.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import Models
import UIKit

enum PaymentCardDecoStep {
    case pop
    case paymentCardListView
    case completePaymentCardDeco
}

final class PaymentCardDecoReactor: Reactor {

    typealias Space = PaymentCardModels.FetchCardList.Response.Space
    
    enum Action {
        case viewDidLoad
        case didTapBackButton
        case didTapCloseButton
        case didTapColor(CardColor)
        case didTapDate(Date)
        case deleteImage(String)
        case addImage(UIImage)
        case didTapCompleteButton
    }

    enum Mutation {
        case updateBankAccount(BankAccount)
        case routeTo(PaymentCardDecoStep)
        case updateImageURLs(String)
        case updatePaymentCardColor(CardColor)
        case updatePaymentCardDate(Date)
    }

    struct State {
        var paymentCard: PaymentCardModels.CreateCard.Request
        var imageURLs: [String] = []
        var selectedColor: CardColor = .pink
        var selectedDate: Date = Date()
        var bankAccount: BankAccount
        @Pulse var step: PaymentCardDecoStep?
    }

    let initialState: State

    init(
        paymentCard: PaymentCardModels.CreateCard.Request,
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        uploadImageUseCase: UploadImageUseCase = UploadImageUseCaseImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl()
    ) {
        self.initialState = .init(paymentCard: paymentCard, bankAccount: .init(bank: "", accountHolderName: "", accountNumber: ""))
        self.uploadImageUseCase = uploadImageUseCase
        self.getUserAccountUseCase = getUserAccountUseCase
        self.paymentCardService = paymentCardService
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let getUserAccount = getUserAccountUseCase.getUserAccount()
                .compactMap { $0 }
                .map { Mutation.updateBankAccount($0.bankAccount)}
            let initailDate = Observable.just(Mutation.updatePaymentCardDate(Date()))
            let bgColor = Observable.just(Mutation.updatePaymentCardColor(.pink))
            let initialImage = Observable.just(Mutation.updateImageURLs(""))
            return .concat([getUserAccount, initailDate, bgColor, initialImage])
        case .didTapBackButton:
            return .just(.routeTo(.pop))
        case .didTapCloseButton:
            return .just(.routeTo(.paymentCardListView))
        case .didTapColor(let color):
            return .just(.updatePaymentCardColor(color))
        case .didTapDate(let date):
            return .just(.updatePaymentCardDate(date))
        case .deleteImage(let imageURL):
            return .just(.updateImageURLs(imageURL))
        case .addImage(let image):
            return uploadImageUseCase.uploadCard(request: .init(image: image))
                .map { .updateImageURLs($0.imageURL) }
        case .didTapCompleteButton:
            let createCard = reqeustCreateCard()
            return createCard
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateBankAccount(let bankAccount):
            newState.bankAccount = bankAccount
            newState.paymentCard.bank = bankAccount.bank
            newState.paymentCard.holder = bankAccount.accountHolderName
            newState.paymentCard.accountNumber = bankAccount.accountNumber
        case .routeTo(let step):
            newState.step = step
        case .updatePaymentCardDate(let date):
            let dateString = Formatter.fullDateFormatter.string(from: date)
            newState.paymentCard.paymentDate = Formatter.addTimeZone(dateString: dateString)
            newState.selectedDate = date
        case .updatePaymentCardColor(let color):
            newState.paymentCard.bgColor = color.rawValue
            newState.selectedColor = color
        case .updateImageURLs(let imageURL):
            // 빈 스트링일 경우 빈 배열 반환
            if imageURL.isEmpty {
                newState.imageURLs = currentState.imageURLs
            } else {
                // 추가하기, 취소하기
                if let firstIndex = currentState.imageURLs.firstIndex(where: { $0 == imageURL }) {
                    newState.imageURLs.remove(at: firstIndex)
                } else {
                    newState.imageURLs.append(imageURL)
                }
            }
        }
        print(newState)
        return newState
    }

    private func reqeustCreateCard() -> Observable<Mutation> {
        return paymentCardService.createCard(request: currentState.paymentCard)
            .map { _ in .routeTo(.completePaymentCardDeco) }
    }

    private let getUserAccountUseCase: GetUserAccountUseCase
    private let paymentCardService: PaymentCardService
    private let uploadImageUseCase: UploadImageUseCase
}
