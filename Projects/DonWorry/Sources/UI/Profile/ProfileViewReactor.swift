//
//  ProfileViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/25.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit

enum ProfileStep {
    case none
    case pop
    case profileImageSheet
    case nicknameEdit
    case accountEdit
    case deleteAccountSheet
}

final class ProfileViewReactor: Reactor {
    private let userService: UserService
    private var user: User
    enum Action {
        case viewWillAppear
        
        case pressBackButton
        
        case pressUpdateProfileImageButton
        case pressUpdateNickNameButton
        case pressUpdateAccountButton
        
        case pressNoticeButton
        case pressTermButton
        case pressPushSettingButton
        
        case inquiryButtonPressed
        case questionsButtonPressed
        case blogButtonPressed
        
        case pressLogoutButton
        case pressAccountDeleteButton
    }
    
    enum Mutation {
        case updateUser(User)
        case routeTo(step: ProfileStep)
    }
    
    struct State {
        var nickname: String
        var imageURL: String
        var bank: String
        var accountNumber: String
        var accountHolder: String
        @Pulse var reload: Void?
        @Pulse var step: ProfileStep?
    }
    
    let initialState: State
    
    init(userService: UserService = UserServiceImpl()) {
        self.userService = userService
        self.user = userService.fetchLocalUser()!
        self.initialState = State(
            nickname: user.nickName,
            imageURL: user.image,
            bank: user.bankAccount.bank,
            accountNumber: user.bankAccount.accountNumber,
            accountHolder: user.bankAccount.accountHolderName
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(Mutation.updateUser(userService.fetchLocalUser()!))
            
        case .pressBackButton:
            return .just(.routeTo(step: .pop))
            
        case .pressUpdateProfileImageButton:
            return .just(.routeTo(step: .profileImageSheet))
            
        case .pressUpdateNickNameButton:
            return .just(Mutation.routeTo(step: .nicknameEdit))
            
        case .pressUpdateAccountButton:
            return .just(Mutation.routeTo(step: .accountEdit))
            
        case .pressNoticeButton:
            // TODO: 공지사항
            return .empty()
            
        case .pressTermButton:
            // TODO: 이용약관
            return .empty()
            
        case .pressPushSettingButton:
            // TODO: 알림설정
            return .empty()
            
        case .inquiryButtonPressed:
            // TODO: 1대1 문의
            return .empty()
            
        case .questionsButtonPressed:
            // TODO: 자주 찾는 질문
            return .empty()
            
        case .blogButtonPressed:
            // TODO: 블로그
            return .empty()
            
        case .pressLogoutButton:
            userService.deleteLocalUser()
            
        case .pressAccountDeleteButton:
            return .just(.routeTo(step: .deleteAccountSheet))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateUser(let user):
            newState.imageURL = user.image
            newState.nickname = user.nickName
            newState.bank = user.bankAccount.bank
            newState.accountHolder = user.bankAccount.accountHolderName
            newState.accountNumber = user.bankAccount.accountNumber
            newState.reload = ()
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
