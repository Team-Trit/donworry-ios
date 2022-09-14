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
    private let getUserUseCase: GetUserAccountUseCase
    private let uploadImageUseCase: UploadImageUseCase
    
    private var user: User
    enum Action {
        case viewWillAppear
        case pressBackButton
        case pressUpdateProfileImageButton
        case updateProfileImage(image: UIImage)
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
        var nickname: String
        var imageURL: String
        var bank: String
        var accountNumber: String
        var accountHolder: String
        @Pulse var reload: Void?
        @Pulse var step: ProfileStep?
    }
    
    let initialState: State
    
    init(
        userService: UserService = UserServiceImpl(),
        getUserUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        uploadImageUseCase: UploadImageUseCase = UploadImageUseCaseImpl()
    ) {
        self.userService = userService
        self.getUserUseCase = getUserUseCase
        self.user = getUserUseCase.getUserAccountUnWrapped()!
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
            guard let currentUser = getUserUseCase.getUserAccountUnWrapped() else { return .empty() }
            return .just(Mutation.updateUser(currentUser))
            
        case .pressBackButton:
            return .just(.routeTo(step: .pop))
            
        case .pressUpdateProfileImageButton:
            return .just(.routeTo(step: .profileImageSheet))
            
        case .updateProfileImage(let image):
            uploadImageUseCase.uploadProfileImage(request: .init(image: image, type: "profile"))
                .subscribe(onNext: { url in
                    
                })
            
            
            
            return userService.updateUser(nickname: nil,
                                   imgURL: imgURL,
                                   bank: nil,
                                   holder: nil,
                                   accountNumber: nil,
                                   isAgreeMarketing: nil)
            .map { return .updateUser($0) }
            
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
