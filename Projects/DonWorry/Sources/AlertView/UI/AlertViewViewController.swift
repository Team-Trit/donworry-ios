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


final class AlertViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = AlertViewViewModel()
    
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
        tableView.dataSource = self
        tableView.delegate = self
        layout()
    }
}

extension AlertViewViewController {

    private func layout() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension AlertViewViewController: UITableViewDataSource {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !viewModel.sortedMessages[section].isEmpty {
            return "\(viewModel.sortedMessages[section][0].recievedDate)"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension AlertViewViewController: UITableViewDelegate {
    
}