//
//  ProfileViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/25.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

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
    private let getUserAccountUseCase: GetUserAccountUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let updateProfileImageUseCase: UpdateProfileImageUseCase
    private let disposeBag: DisposeBag

    enum Action {
        case viewWillAppear
        case pressBackButton
        case pressUpdateProfileImageButton
        case updateProfileImage(image: UIImage?)
        case pressUpdateNickNameButton
        case pressUpdateAccountButton
        case pressNoticeButton
        case pressTermButton
        case pressPushSettingButton
        case pressInquiryButton
        case pressQuestionButton
        case pressBlogButton
        case pressLogoutButton
        case pressAccountDeleteButton
        case deleteAccount
    }
    
    enum Mutation {
        case updateUser(User)
        case routeTo(step: ProfileStep)
    }
    
    struct State {
        var user: Models.User
        @Pulse var step: ProfileStep?
    }
    
    let initialState: State
    
    init(
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        uploadImageUseCase: UploadImageUseCase = UploadImageUseCaseImpl(),
        updateProfileImageUseCase: UpdateProfileImageUseCase = UpdateProfileImageUseCaseImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.updateProfileImageUseCase = updateProfileImageUseCase
        disposeBag = .init()
        self.initialState = State(
            user: User(id: -1, nickName: "", bankAccount: BankAccount(bank: "", accountHolderName: "", accountNumber: ""), image: "")
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return getUserAccountUseCase.getUserAccount()
                .map { .updateUser($0!) }
            
        case .pressBackButton:
            return .just(.routeTo(step: .pop))
            
        case .pressUpdateProfileImageButton:
            return .just(.routeTo(step: .profileImageSheet))
            
        case .updateProfileImage(let image):
            return uploadImageUseCase.uploadProfileImage(request: .init(image: image!, type: "profile"))
                .map { [weak self] response in
                    return .updateUser(User(id: self!.currentState.user.id,
                                            nickName: self!.currentState.user.nickName,
                                            bankAccount: BankAccount(bank: self!.currentState.user.bankAccount.bank,
                                                                     accountHolderName: self!.currentState.user.bankAccount.accountHolderName,
                                                                     accountNumber: self!.currentState.user.bankAccount.accountNumber),
                                            image: response.imageURL))
                }

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
            
        case .pressInquiryButton:
            // TODO: 1대1 문의
            return .empty()
            
        case .pressQuestionButton:
            // TODO: 자주 찾는 질문
            return .empty()
            
        case .pressBlogButton:
            // TODO: 블로그
            return .empty()
            
        case .pressLogoutButton:
            return .empty()
            
        case .pressAccountDeleteButton:
            return .just(.routeTo(step: .deleteAccountSheet))
            
        case .deleteAccount:
            // TODO: 회원 탈퇴 API 호출
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateUser(let user):
            newState.user = user
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
