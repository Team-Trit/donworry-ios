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
    var items = [ProfileViewModelItem]()
    
    init() {
        super.init(frame: .zero, style: .grouped)
        
        items.append(ProfileViewModelUserItem(nickName: "Charlie", name: "Kim", imageURL: "profile-sample"))
        items.append(ProfileViewModelAccountItem(bank: "우리은행", account: "1234-1234-1234", holder: "김승창"))
        items.append(ProfileViewModelServiceItem(label: "공지사항"))
        items.append(ProfileViewModelServiceItem(label: "이용약관"))
        items.append(ProfileViewModelServiceItem(label: "1대1 문의"))
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension ProfileTableView {
    private func configure() {
        self.backgroundColor = .designSystem(.white)
        self.dataSource = self
        self.delegate = self
        self.register(ProfileTableViewUserCell.self, forCellReuseIdentifier: ProfileTableViewUserCell.identifier)
        self.register(ProfileTableViewAccountCell.self, forCellReuseIdentifier: ProfileTableViewAccountCell.identifier)
        self.register(ProfileTableViewServiceCell.self, forCellReuseIdentifier: ProfileTableViewServiceCell.identifier)
        self.allowsSelection = false
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSource
extension ProfileTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .user:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewUserCell.identifier, for: indexPath) as? ProfileTableViewUserCell {
                cell.user = item
                return cell
            }
        case .account:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewAccountCell.identifier, for: indexPath) as? ProfileTableViewAccountCell {
                cell.account = item
                return cell
            }
        case.service:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewServiceCell.identifier, for: indexPath) as? ProfileTableViewServiceCell {
                cell.service = item
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row].type {
        case .user:
            return 130
        case .account:
            return 170
        case .service:
            return 80
        }
    }
}
