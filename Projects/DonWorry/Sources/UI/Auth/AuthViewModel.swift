//
//  AuthViewModel.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/03.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import RxSwift

final class AuthViewModel {
    static let shared = AuthViewModel()
    let accessToken = PublishSubject<String>()
    let bank = PublishSubject<Bank>()
    
    private init() {}
}
