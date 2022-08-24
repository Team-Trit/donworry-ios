//
//  ConfirmTermViewModel.swift
//  App
//
//  Created by 김승창 on 2022/08/17.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation

import BaseArchitecture
import RxSwift

final class ConfirmTermViewModel: BaseViewModel {
    var checkedTerms: [Term] = [
        Term(label: "전체동의"),
        Term(label: "만 14세 이상입니다.", isChecked: true, children: [
            Term(label: "1-1"),
            Term(label: "1-2")
        ]),
        Term(label: "돈워리 서비스 이용약관 동의", isChecked: true, children: [
            Term(label: "2-1"),
            Term(label: "2-2")
        ]),
        Term(label: "돈워리의 개인정보 수집 및 이용에 동의", isChecked: true, children: [
            Term(label: "3-1")
        ]),
        Term(label: "돈워리 개인정보 제 3자 제공 동의", isChecked: true),
        Term(label: "이벤트 알림 수신 동의", isChecked: true)
    ]
}
