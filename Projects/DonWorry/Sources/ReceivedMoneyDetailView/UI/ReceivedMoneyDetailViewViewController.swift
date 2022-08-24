//
//  ReceivedMoneyDetailViewViewController.swift
//  App
//
//  Created by uiskim on 2022/08/13.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

import BaseArchitecture
import DesignSystem


final class RecievedMoneyDetailViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = ReceivedMoneyDetailViewViewModel()
    
    private var statusView: RecieveMoneyDetailStatusView = {
        let status = RecieveMoneyDetailStatusView()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.configure(payment: 12000, outstanding: 24000)
        return status
    }()
                         
     private let separatorView: UIView = {
         let separatorView = UIView()
         separatorView.translatesAutoresizingMaskIntoConstraints = false
         separatorView.backgroundColor = .designSystem(.white)
         return separatorView
     }()
    
    private let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.text = "상세내역"
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return subTitle
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecievedMoneyTableViewCell.self, forCellReuseIdentifier: RecievedMoneyTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private let buttomButton: UIButton = {
       let buttonButton = UIButton()
        buttonButton.frame = CGRect(x: 21, y: 700, width: 340, height: 50)
        buttonButton.backgroundColor = .designSystem(.mainBlue)
        buttonButton.layer.masksToBounds = true
        buttonButton.layer.cornerRadius = 25
        buttonButton.setTitle("재촉하기", for: .normal)
        buttonButton.setTitleColor(.white, for: .normal)
        buttonButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return buttonButton
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attributes()
        layout()
    }


}

extension RecievedMoneyDetailViewViewController {

    private func attributes() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubview(statusView)
        statusView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 10).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(subTitle)
        subTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
        subTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        subTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 440).isActive = true
        
        view.addSubview(buttomButton)
    }
}

extension RecievedMoneyDetailViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecievedMoneyTableViewCell.identifier, for: indexPath)
                as? RecievedMoneyTableViewCell else { return UITableViewCell() }
        cell.configure(viewModel.contents[indexPath.row])
        return cell
    }
}

extension RecievedMoneyDetailViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}