//
//  EnterUserInfoViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit

enum EnterUserInfoStep {
    case none
    case pop
    case selectBank(delegate: EnterUserInfoViewDelegate)
    case agreeTerm(AuthModels.SignUp.Request)
}

final class EnterUserInfoViewReactor: Reactor {
    typealias SignUpModel = AuthModels.SignUp.Request
    typealias OAuthType = AuthModels.OAuthType
    private let checkNicknameUseCase: CheckNicknameUseCase
    
    enum TextFieldType {
        case nickname
        case accountHolder
        case accountNumber
    }
    
    enum Action {
        case backButtonPressed
        case nicknameFieldUpdated(nickname: String)
        case accountHolderFieldUpdated(holder: String)
        case accountNumberFieldUpdated(number: String)
        case bankSelectButtonPressed
        case bankSelected(_ selectedBank: String)
        case nextButtonPressed
    }
    
    enum Mutation {
        case updateSubject(type: TextFieldType, _ value: String)
        case updateBank(selectedBank: String)
        case showToast(message: String)
        case routeTo(step: EnterUserInfoStep)
    }
    
    struct State {
        var signUpModel: SignUpModel
        @Pulse var isNextButtonAvailable: Bool
        @Pulse var toast: String?
        @Pulse var step: EnterUserInfoStep?
    }
    
    let initialState: State
    
    init(oauthType: OAuthType,
         token: String,
         authorizationCode: String,
         checkNicknameUseCase: CheckNicknameUseCase = CheckNicknameUseCaseImpl()
    ) {
        var signUpModel = SignUpModel.initialValue
        signUpModel.token = token
        signUpModel.oauthType = oauthType
        signUpModel.authorizationCode = authorizationCode
        print(signUpModel)
        self.checkNicknameUseCase = checkNicknameUseCase
        self.initialState = State(signUpModel: signUpModel, isNextButtonAvailable: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonPressed:
            return .just(.routeTo(step: .pop))
            
        case .nicknameFieldUpdated(let nickname):
            return .just(.updateSubject(type: .nickname, nickname))
            
        case .accountHolderFieldUpdated(let holder):
            return .just(Mutation.updateSubject(type: .accountHolder, holder))
            
        case .accountNumberFieldUpdated(let number):
            return .just(Mutation.updateSubject(type: .accountNumber, number))
            
        case .bankSelectButtonPressed:
            return .just(.routeTo(step: .selectBank(delegate: self)))
        case .bankSelected(let bank):
            return .just(Mutation.updateBank(selectedBank: bank))
        case .nextButtonPressed:
            let checkNickname = checkNickname(nickname: currentState.signUpModel.nickname)
            return checkNickname
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateSubject(type, value):
            switch type {
            case .nickname:
                newState.signUpModel.nickname = value
            case .accountHolder:
                newState.signUpModel.bankHolder = value
            case .accountNumber:
                newState.signUpModel.bankNumber = value
            }
        case .updateBank(let bank):
            newState.signUpModel.bank = bank
            
        case .showToast(let message):
            newState.toast = message

        case .routeTo(let step):
            newState.step = step
        }
        newState.isNextButtonAvailable = checkNextButtonValidation(newState)
        return newState
    }
}

// MARK: - Helper
extension EnterUserInfoViewReactor: EnterUserInfoViewDelegate {
    private func checkNextButtonValidation(_ state: State) -> Bool {
        return state.signUpModel.nickname != "" && state.signUpModel.bankHolder != "" && state.signUpModel.bankNumber != "" && state.signUpModel.bank != "은행선택"
    }
    
    func saveBank(_ selectedBank: String) {
        self.action.onNext(Action.bankSelected(selectedBank))
    }
    
    private func checkNickname(nickname: String) -> Observable<Mutation> {
        checkNicknameUseCase.checkNickname(nickname: nickname)
            .map { _ in .routeTo(step: .agreeTerm(self.currentState.signUpModel)) }
            .catch { error in
                guard let error = error.toAuthError() else { return .error(error)}

                switch error {
                case .duplicatedNickname:
                    return .just(.showToast(message: "현재 사용 중인 닉네임입니다."))
                    
                default:
                    return .just(.routeTo(step: .agreeTerm(self.currentState.signUpModel)))
                }
            }
    }
}
