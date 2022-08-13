//
//  ConfirmTermViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/13.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import RxCocoa
import RxSwift

final class ConfirmTermViewController: BaseViewController {
    private lazy var confirmTableView: ConfirmTermTableView = {
        let v = ConfirmTermTableView()
        v.dataSource = self
        v.delegate = self
        v.register(ConfirmTermTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: ConfirmTermTableViewHeaderView.identifier)
        v.register(UITableViewCell.self, forCellReuseIdentifier: "TermConfirmCell")
        
        // MARK: ConfirmTermTableView로 옮기고 싶은데 적용이 안됨
        v.backgroundColor = .blue
        v.separatorStyle = .none
        v.showsVerticalScrollIndicator = false
        v.allowsSelection = false
        return v
    }()
    private lazy var confirmButton: LargeButton = {
        let v = LargeButton(type: .done)
        v.addTarget(self, action: #selector(confirmButtonPressed(_:)), for: .touchUpInside)
        return v
    }()
    private let checkedTerms = terms.filter { $0.isChecked }
    let viewModel = ConfirmTermViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        confirmTableView.dataSource = self
        confirmTableView.delegate = self
        confirmTableView.register(ConfirmTermTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: ConfirmTermTableViewHeaderView.identifier)
        confirmTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TermConfirmCell")
        setUI()
    }
}

// MARK: - Layout
extension ConfirmTermViewController {
    private func setUI() {
        view.addSubviews(confirmTableView, confirmButton)
        
        confirmTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - TableViewDataSource
extension ConfirmTermViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkedTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermConfirmCell", for: indexPath)
        cell.textLabel?.text = "* \(checkedTerms[indexPath.row].title)"
        cell.textLabel?.font = .designSystem(weight: .regular, size: ._15)
        cell.textLabel?.textColor = .designSystem(.gray1)
        return cell
    }
}

// MARK: - TableViewDelegate
extension ConfirmTermViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ConfirmTermTableViewHeaderView.identifier)  as? ConfirmTermTableViewHeaderView else { return UIView() } 
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

// MARK: - Interaction Functions
extension ConfirmTermViewController {
    @objc private func confirmButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
        // TODO: 회원가입 완료 후 HomeView로 이동
    }
}
