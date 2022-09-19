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
    case pop
    case profileImageSheet
    case nicknameEdit
    case accountEdit
    case deleteAccountSheet
    case login
}

final class ProfileViewReactor: Reactor {
    private let getUserAccountUseCase: GetUserAccountUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let updateProfileImageUseCase: UpdateProfileImageUseCase
    private let logoutUseCase: LogoutUseCase
    private let deRegisterUseCase: DeRegisterUseCase

    enum Action {
        case viewWillAppear
        case pressBackButton
        case pressUpdateProfileImageButton
        case updateProfileImage(image: UIImage?)
        case pressUpdateNickNameButton
        case pressUpdateAccountButton
        case pressServiceButton(index: Int)
        case pressLogoutButton
        case pressAccountDeleteButton
        case deleteAccount
    }
    
    enum Mutation {
        case updateUser(User)
        case routeTo(step: ProfileStep)
        case error(String?)
    }
    
    struct State {
        var user: Models.User

        @Pulse var error: String?
        @Pulse var step: ProfileStep?
    }
    
    let initialState: State
    
    init(
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        uploadImageUseCase: UploadImageUseCase = UploadImageUseCaseImpl(),
        updateProfileImageUseCase: UpdateProfileImageUseCase = UpdateProfileImageUseCaseImpl(),
        logoutUseCase: LogoutUseCase = LogoutUseCaseImpl(),
        deRegisterUseCase: DeRegisterUseCase = DeRegisterUseCaseImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.updateProfileImageUseCase = updateProfileImageUseCase
        self.logoutUseCase = logoutUseCase
        self.deRegisterUseCase = deRegisterUseCase
        self.initialState = State(
            user: User(id: -1, nickName: "", bankAccount: BankAccount(bank: "", accountHolderName: "", accountNumber: ""), image: "")
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return getUserAccountUseCase.getUserAccount()
                .map { user in
                    guard let user = user else { return .routeTo(step: .pop) }
                    return .updateUser(user)
                }
            
        case .pressBackButton:
            return .just(.routeTo(step: .pop))
            
        case .pressUpdateProfileImageButton:
            return .just(.routeTo(step: .profileImageSheet))
            
        case .updateProfileImage(let image):
            guard let image = image else { return .empty() }
            return uploadImageUseCase.uploadProfileImage(request: .init(image: image, type: "profile"))
                .flatMap { [weak self] response in
                    (self?.updateProfileImageUseCase.updateProfileImage(imgURL: response.imageURL)
                        .compactMap { Mutation.updateUser($0) }) ?? .just(.error("프로필 이미지 업데이트 실패!"))
                }

        case .pressUpdateNickNameButton:
            return .just(Mutation.routeTo(step: .nicknameEdit))
            
        case .pressUpdateAccountButton:
            return .just(Mutation.routeTo(step: .accountEdit))
            
        case .pressServiceButton(let index):
            switch index {
            case 2:
                // 공지사항
                if let url = URL(string: "https://www.notion.so/6772fa482cf74c54893350fde6b08f12") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                
            case 3:
                // 이용약관
                if let url = URL(string: "https://www.notion.so/0ec63d93d3f3407e8b881575ac952533") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                
            default:
                break
            }
            return .empty()
            
        case .pressLogoutButton:
            return logoutUseCase.logout()
                .map { _ in return .routeTo(step: .login) }
            
        case .pressAccountDeleteButton:
            return .just(.routeTo(step: .deleteAccountSheet))
            
        case .deleteAccount:
            return deRegisterUseCase.deregister().map { _ in .routeTo(step: .login) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateUser(let user):
            newState.user = user
            
        case .routeTo(let step):
            newState.step = step

        case .error(let message):
            newState.error = message
        }
        
        return newState
    }
}
