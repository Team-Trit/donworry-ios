//
//  ConfirmTermTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem

final class ConfirmTermTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension ConfirmTermTableView {
    private func configure() {
        self.backgroundColor = .designSystem(.white)
        self.register(ConfirmTermTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ConfirmTermTableViewHeader.identifier)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "TermConfirmCell")
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.allowsSelection = false
        self.isScrollEnabled = false
    }
}
