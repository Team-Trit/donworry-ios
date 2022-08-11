//
//  TermConfirmView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import DonWorryExtensions

final class TermConfirmViewController: BaseViewController {
    private let tableView = UITableView()
    private let confirmButton = LargeButton(type: .done)
    private let checkedTerms = terms.filter { $0.isChecked }
    let viewModel = TermConfirmViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension TermConfirmViewController {
    private func attributes() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TermConfirmHeader")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TermConfirmCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: - DataSource Methods
extension TermConfirmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkedTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermConfirmCell", for: indexPath)
        cell.textLabel?.text = "* \(checkedTerms[indexPath.row].title)"
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.textLabel?.textColor = .designSystem(.gray1)
        return cell
    }
}


// MARK: - Delegate Methods
extension TermConfirmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UITableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TermConfirmHeader")!
        let titleLabel = UILabel()
        titleLabel.text = "\(Date().formatted("yyyy년 M월 dd일")) 알림 수신을\n아래와 같이 설정하였습니다."
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 0
        header.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: header.contentView.trailingAnchor, constant: -25),
            titleLabel.topAnchor.constraint(equalTo: header.contentView.topAnchor, constant: 10)
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

// MARK: - Interaction Functions
extension TermConfirmViewController {
    @objc private func confirmButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
        // TODO: 회원가입 완료 후 HomeView로 이동
    }
}
