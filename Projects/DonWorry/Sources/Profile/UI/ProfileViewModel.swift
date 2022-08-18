//
//  ProfileViewModel.swift
//  App
//
//  Created by 김승창 on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation

import BaseArchitecture
import RxSwift

class ProfileViewModel: BaseViewModel {
    
}

enum ProfileViewModelItemType {
    case user
    case account
    case service
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
}

class ProfileViewModelUserItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .user
    }
    var nickName: String
    var name: String
    var imageURL: String
    
    init(nickName: String, name: String, imageURL: String) {
        self.nickName = nickName
        self.name = name
        self.imageURL = imageURL
    }
}

class ProfileViewModelAccountItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .account
    }
    var bank: String
    var account: String
    var holder: String
    
    init(bank: String, account: String, holder: String) {
        self.bank = bank
        self.account = account
        self.holder = holder
    }
}

class ProfileViewModelServiceItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .service
    }
    var label: String
    
    init(label: String) {
        self.label = label
    }
}
