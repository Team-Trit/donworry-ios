//
//  AgreeTermTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

final class AgreeTermTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension AgreeTermTableView {
    private func configure() {
        self.backgroundColor = .designSystem(.white)
        self.register(AgreeTermTableViewCell.self, forCellReuseIdentifier: AgreeTermTableViewCell.identifier)
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.allowsSelection = false
    }
}
