//
//  ConfirmTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow

final class ConfirmTermViewReactor: Reactor, Stepper {
    let checkedTerms: [String]
    // User Info
    private let accessToken: String
    private let nickname: String
    private let bank: String
    private let holder: String
    private let number: String
    private let isAgreeMarketing: Bool
    private let userService: UserService
    
    let steps = PublishRelay<Step>()
    enum Action {
        case confirmButtonPressed
    }
    
    enum Mutation {
//        case signUpComplete
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init(checkedTerms: [String], accessToken: String, nickname: String, bank: String, holder: String, number: String, isAgreeMarketing: Bool) {
        self.initialState = State()
        self.checkedTerms = checkedTerms
        self.accessToken = accessToken
        self.nickname = nickname
        self.bank = bank
        self.holder = holder
        self.number = number
        self.isAgreeMarketing = isAgreeMarketing
        self.userService = UserServiceImpl()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonPressed:
            // TODO: API call
            print("🌈")
            
            userService.signUp(provider: "뭘로할까", nickname: nickname, email: "qweqwe@qwe.com", bank: bank, bankNumber: number, bankHolder: holder, isAgreeMarketing: isAgreeMarketing, accessToken: accessToken)
                .subscribe(onNext: { user in
                    self.userService.saveToLocalStorage(id: user.id, nickname: user.nickName, bank: user.bankAccount.bank, bankHolder: user.bankAccount.accountHolderName, bankNumber: user.bankAccount.accountNumber, image: user.image, accessToken: self.accessToken)
                }, onError: { error in
                    print("에러다에러")
                    print(error)
                }, onCompleted: {
                    self.steps.accept(DonworryStep.homeIsRequired)
                })
                .disposed(by: DisposeBag())
            
            return .empty()
//            saveToLocalStorage
            
//            return userService.signUp(provider: "뭘로할까", nickname: nickname, email: "qweqwe@qwe.com", bank: bank, bankNumber: number, bankHolder: holder, isAgreeMarketing: isAgreeMarketing, accessToken: accessToken)
//                .map { _ in Mutation.signUpComplete }
            //            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
//        case .signUpComplete:
//            self.steps.accept(DonworryStep.homeIsRequired)
        }
        
        return state
    }
}
