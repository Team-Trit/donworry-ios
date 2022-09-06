//
//  ProfileTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class ProfileTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        self.backgroundColor = .designSystem(.white)
        self.register(ProfileTableViewUserCell.self, forCellReuseIdentifier: ProfileTableViewUserCell.identifier)
        self.register(ProfileTableViewAccountCell.self, forCellReuseIdentifier: ProfileTableViewAccountCell.identifier)
        self.register(ProfileTableViewServiceCell.self, forCellReuseIdentifier: ProfileTableViewServiceCell.identifier)
        self.allowsSelection = false
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .none
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
