//
//  AgreeTermTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture

struct Term {
    let title: String
    let details: [String]
    var isChecked: Bool
    var showsDetail: Bool
}

let terms: [Term] = [
    Term(title: "전체동의", details: [], isChecked: false, showsDetail: false),
    Term(title: "만 14세 이상입니다.", details: ["1-1", "1-2", "1-3"], isChecked: true, showsDetail: true),
    Term(title: "돈워리 서비스 이용약관 동의", details: ["2-1", "2-2"], isChecked: true, showsDetail: false),
    Term(title: "돈워리의 개인정보 수집 및 이용에 동의", details: ["3-1", "3-2", "3-3"], isChecked: true, showsDetail: true),
    Term(title: "돈워리 개인정보 제 3자 제공 동의", details: ["4-1"], isChecked: false, showsDetail: false),
    Term(title: "이벤트 알림 수신 동의", details: ["5-1", "5-2", "5-3"], isChecked: false, showsDetail: true)
]

final class AgreeTermTableView: UITableView {
    private lazy var agreeTermTableView = UITableView()

    init() {
        super.init(frame: .zero, style: .grouped)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension AgreeTermTableView {
    private func setUI() {
        addSubview(agreeTermTableView)
        agreeTermTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
