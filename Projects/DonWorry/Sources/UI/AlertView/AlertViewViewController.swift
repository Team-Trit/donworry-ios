//
//  AlertViewViewController.swift
//  App
//
//  Created by uiskim on 2022/08/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift
import SnapKit
import DesignSystem

final class AlertViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = AlertViewViewModel()
    
    private lazy var navigationBar = DWNavigationBar(title: "알림", rightButtonTitle: "전체삭제")
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorColor = UIColor.clear
        return tableView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        layout()
        bind()
    }
}

extension AlertViewViewController {
    private func bind() {
        navigationBar.leftItem.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationBar.rightItem!.rx.tap
            .bind {
                // TODO: 전체 삭제
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubviews(navigationBar, tableView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25).isActive = true
    }
}

extension AlertViewViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sortedMessages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedMessages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier, for: indexPath) as? AlertTableViewCell else { return UITableViewCell()}
        
        let messageTuple = viewModel.sortedMessages[indexPath.section]
        cell.configure(message: messageTuple[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.sortedMessages[section].isNotEmpty {
            return "\(viewModel.sortedMessages[section][0].recievedDate)"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
