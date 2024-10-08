//
//  PaymentCardIconEditViewReactor.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum PaymentCardIconEditStep {
    case pop
    case paymentCardAmountEdit
    case paymentCardList
}

final class PaymentCardIconEditViewReactor: Reactor {
    
    typealias Space = PaymentCardModels.FetchCardList.Response.Space

    enum Action {
        case viewDidLoad
        case didTapBackButton
        case didTapNextButton
        case didTapCloseButton
        case didTapIconCell(Int)
    }

    enum Mutation {
        case updateCategories(CategoryModels.FetchAll.Response)
        case routeTo(PaymentCardIconEditStep)
        case updateCategory(Int)
        case updatePaymentCard(String)
    }

    struct State {
        var categoryCellViewModel: [PaymentIconCellViewModel] = []
        var paymentCard: PaymentCardModels.CreateCard.Request
        var isNextButtonEnabled: Bool  = false
        @Pulse var step: PaymentCardIconEditStep?
    }

    let initialState: State

    init(
        getAllCategoriesUseCase: GetAllCategoriesUseCase = GetAllCategoriesUseCaseImpl(),
        paymentCard: PaymentCardModels.CreateCard.Request
    ) {
        self.getAllCategoriesUseCase = getAllCategoriesUseCase
        self.initialState = .init(paymentCard: paymentCard)
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return getAllCategoriesUseCase.getAllCategories().map { .updateCategories($0) }
        case .didTapBackButton:
            return .just(.routeTo(.pop))
        case .didTapNextButton:
            return .just(.routeTo(.paymentCardAmountEdit))
        case .didTapCloseButton:
            return .just(.routeTo(.paymentCardList))
        case .didTapIconCell(let categoryID):
            let updateCategory = Observable.just(Mutation.updateCategory(categoryID))
            let getCategoryImageName = getAllCategoriesUseCase.findCategoryImageName(by: categoryID)
                .map { categoryImageName in Mutation.updatePaymentCard(String(categoryImageName) )}
            return .concat([updateCategory, getCategoryImageName])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateCategories(let categories):
            newState.categoryCellViewModel = categories.map { .init(id: $0.id, imageName: $0.name, imageURL: $0.imgURL) }
        case .routeTo(let step):
            newState.step = step
        case .updateCategory(let categoryID):
            newState.paymentCard.categoryID = categoryID
            if categoryID > -1 {
                newState.isNextButtonEnabled = true
            } else {
                newState.isNextButtonEnabled = false
            }
        case .updatePaymentCard(let categoryName):
            newState.paymentCard.viewModel.categoryIconName = categoryName
        }
        return newState
    }

    private let getAllCategoriesUseCase: GetAllCategoriesUseCase
}
