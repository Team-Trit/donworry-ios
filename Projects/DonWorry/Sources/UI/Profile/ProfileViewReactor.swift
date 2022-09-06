//
//  ProfileViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/25.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

enum ProfileStep {
    case nicknameEdit
    case accountEdit
    
    // TODO: 공지사항, 이용약관, 1대1 문의 등등 추가
    
    case pop
    case none
}

final class ProfileViewReactor: Reactor {
    enum Action {
        case backButtonPressed
        
        case updateProfileImageButtonPressed
        case updateNickNameButtonPressed
        case updateAccountButtonPressed
        
        case noticeButtonPressed
        case termButtonPressed
        case pushSettingButtonPressed
        
        case inquiryButtonPressed
        case questionsButtonPressed
        case blogButtonPressed
        
        case logoutButtonPressed
        case accountDeleteButtonPressed
    }
    
    enum Mutation {
        case routeTo(step: ProfileStep)
        
        case showUpdateImageSheet
        
        // TODO: 1대1 문의, 블로그 수정하기
        case inquiry
        case navigateToQuestionVC
        case blog
        
        case logout
        case presentDeleteAccountAlert
    }
    
    struct State {
        @Pulse var step: ProfileStep?
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonPressed:
            return .just(.routeTo(step: .pop))
            
        case .updateProfileImageButtonPressed:
            return .just(Mutation.showUpdateImageSheet)
            
        case .updateNickNameButtonPressed:
            return .just(Mutation.routeTo(step: .nicknameEdit))
            
        case .updateAccountButtonPressed:
            return .just(Mutation.routeTo(step: .accountEdit))
            
        case .noticeButtonPressed:
            return .empty()
            
        case .termButtonPressed:
            return .empty()
            
        case .pushSettingButtonPressed:
            return .empty()
            
        case .inquiryButtonPressed:
            return .just(Mutation.inquiry)
            
        case .questionsButtonPressed:
            return .just(Mutation.navigateToQuestionVC)
            
        case .blogButtonPressed:
            return .just(Mutation.blog)
        
        case .logoutButtonPressed:
            return .just(Mutation.logout)
            
        case .accountDeleteButtonPressed:
            return .just(Mutation.presentDeleteAccountAlert)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .routeTo(let step):
            state.step = step
            
        case .showUpdateImageSheet:
            break
                
        case .inquiry:
            break
        case .navigateToQuestionVC:
            break
        case .blog:
            break
                
        case .logout:
            break
        case .presentDeleteAccountAlert:
            break
        }
        
        return state
    }
}
