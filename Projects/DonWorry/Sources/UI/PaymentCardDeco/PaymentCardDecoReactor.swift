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
    case selectBankView
}

struct CardViewModel {
    var cardColor: CardColor = .pink
    var payDate: Date = Date()
    var bank: String = ""
    var holder: String = ""
    var number: String = ""
    var images: [UIImage?] = []
}

final class PaymentCardDecoReactor: Reactor {

    typealias Space = PaymentCardModels.FetchCardList.Response.Space
    
    enum Action {
        case didTapBackButton
        case didTapCloseButton
        case presentBankSheet
        case updateBank(String)
        case updateHolder(String)
        case updateAccountNumber(String)
        case deleteImage(String)
        case addImage(UIImage)
        case didTapCompleteButton(CardViewModel)
    }

    enum Mutation {
        case updateBank(String)
        case updateHolder(String)
        case updateAccountNumber(String)
        case routeTo(PaymentCardDecoStep)
        case updateImageURLs(String)
    }

    struct State {
        var paymentCard: PaymentCardModels.CreateCard.Request
        var imageURLs: [String] = []

        @Pulse var step: PaymentCardDecoStep?
    }

    let initialState: State

    init(
        paymentCard: PaymentCardModels.CreateCard.Request,
        uploadImageUseCase: UploadImageUseCase = UploadImageUseCaseImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl()
    ){
        self.initialState = .init(paymentCard: paymentCard)
        self.uploadImageUseCase = uploadImageUseCase
        self.paymentCardService = paymentCardService
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        case .didTapBackButton:
            return .just(.routeTo(.pop))
            
        case .didTapCloseButton:
            return .just(.routeTo(.paymentCardListView))
            
        case .presentBankSheet:
            return .just(.routeTo(.selectBankView))
            
        case .updateBank(let bank):
            // TODO: Call update bank API
            return .just(.updateBank(bank))
            
        case .updateHolder(let holder):
            // TODO: Call update holder API
            return .just(.updateHolder(holder))
            
        case .updateAccountNumber(let number):
            // TODO: Call update account number API
            return .just(.updateAccountNumber(number))
            
        case .deleteImage(let imageURL):
            return .just(.updateImageURLs(imageURL))
        case .addImage(let image):
            return uploadImageUseCase.uploadCard(request: .init(image: image))
                .map { .updateImageURLs($0.imageURL) }
        case .didTapCompleteButton:
//            let card = currentState.paymentCard
//            let createCard = paymentCardService
//                                .map { response -> Mutation in
//                                    return Mutation.routeTo(.completePaymentCardDeco)
//                                }
//
//            return createCar
            return .just(.routeTo(.pop))

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateBank(let bank):
            newState.paymentCard.bank = bank
            
        case .updateHolder(let holder):
            newState.paymentCard.holder = holder
            
        case .updateAccountNumber(let number):
            newState.paymentCard.number = number
            
        case .routeTo(let step):
            newState.step = step
        case .updateImageURLs(let imageURL):
            if let firstIndex = currentState.imageURLs.firstIndex(where: { $0 == imageURL }) {
                newState.imageURLs.remove(at: firstIndex)
            } else {
                newState.imageURLs.append(imageURL)
            }
        }
        return newState
    }

    private let paymentCardService: PaymentCardService
    private let uploadImageUseCase: UploadImageUseCase
}

// MARK: - CardDecoViewDelegate
extension PaymentCardDecoReactor: CardDecoViewDelegate {
    func saveBank(_ selectedBank: String) {
        self.action.onNext(.updateBank(selectedBank))
    }
}
