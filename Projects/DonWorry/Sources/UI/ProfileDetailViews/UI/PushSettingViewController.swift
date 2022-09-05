//
//  ProfileDetailViewsViewController.swift
//  App
//
//  Created by uiskim on 2022/09/05.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift

struct Toggle {
    let main: String
    let sub: String
}

final class ProfileDetailViewsViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = ProfileDetailViewsViewModel()
    
    let toggleTitles: [Toggle] = [
        Toggle(main: "정산알림", sub: "정산시작, 정산완료, 재촉"),
        Toggle(main: "서비스 마케팅 알림", sub: "이벤트, 혜택 등")
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PushSettingTableViewCell.self, forCellReuseIdentifier: PushSettingTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        return tableView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        attributes()
        layout()
    }


}

extension ProfileDetailViewsViewController {

    private func attributes() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}

extension ProfileDetailViewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PushSettingTableViewCell.identifier, for: indexPath)
                as? PushSettingTableViewCell else { return UITableViewCell() }
        cell.configure(data: toggleTitles[indexPath.row])
        return cell
    }
    
    
}

extension ProfileDetailViewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView()
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        sectionHeader.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return sectionHeader
    }
}
