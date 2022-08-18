//
//  ConfirmTermTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import SnapKit

final class ConfirmTermTableView: UITableView {
    private var confirmTermTableView = UITableView()
    
    init() {
        super.init(frame: .zero, style: .grouped)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension ConfirmTermTableView {
    private func setUI() {
        addSubview(confirmTermTableView)
        
        confirmTermTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
