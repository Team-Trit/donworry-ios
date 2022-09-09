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
        case deleteImage(String)
        case addImage(UIImage)
        case didTapCompleteButton(CardViewModel)
    }

    enum Mutation {
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
        case .routeTo(let step):
            newState.step = step
        case .updateImageURLs(let imageURL):
            if let firstIndex = currentState.imageURLs.firstIndex(where: { $0 == imageURL }) {
                newState.imageURLs.remove(at: firstIndex)
            } else {
                newState.imageURLs.append(imageURL)
            }
        }
        print(newState)
        return newState
    }

    private let paymentCardService: PaymentCardService
    private let uploadImageUseCase: UploadImageUseCase
}
