//
//  ProfileViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/25.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

enum ProfileStep {
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
        case routeTo(ProfileStep)
        
        case showUpdateImageSheet
        case navigateToUpdateNickNameVC
        case navigateToUpdateAccountVC
        
        case presentNotice
        case navigateToTermsVC
        case navigateToPushSettingVC
        
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
            return .just(.routeTo(.pop))
            
        case .updateProfileImageButtonPressed:
            return .just(Mutation.showUpdateImageSheet)
            
        case .updateNickNameButtonPressed:
            return .just(Mutation.navigateToUpdateNickNameVC)
            
        case .updateAccountButtonPressed:
            return .just(Mutation.navigateToUpdateAccountVC)
            
        case .noticeButtonPressed:
            return .just(Mutation.presentNotice)
            
        case .termButtonPressed:
            return .just(Mutation.navigateToTermsVC)
            
        case .pushSettingButtonPressed:
            return .just(Mutation.navigateToPushSettingVC)
        
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
        case .navigateToUpdateNickNameVC:
            break
        case .navigateToUpdateAccountVC:
            break
                
        case .presentNotice:
            break
        case .navigateToTermsVC:
            break
        case .navigateToPushSettingVC:
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
