//
//  TermTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import UIKit

struct Term {
    let title: String
    let details: [String]
    var isChecked: Bool
    var showsDetail: Bool
}

private let Terms: [Term] = [
    Term(title: "전체동의", details: [], isChecked: false, showsDetail: false),
    Term(title: "만 14세 이상입니다.", details: ["1-1", "1-2", "1-3"], isChecked: true, showsDetail: true),
    Term(title: "돈워리 서비스 이용약관 동의", details: ["2-1", "2-2"], isChecked: true, showsDetail: false),
    Term(title: "돈워리의 개인정보 수집 및 이용에 동의", details: ["3-1", "3-2", "3-3"], isChecked: true, showsDetail: true),
    Term(title: "돈워리 개인정보 제 3자 제공 동의", details: ["4-1"], isChecked: false, showsDetail: false),
    Term(title: "이벤트 알림 수신 동의", details: ["5-1", "5-2", "5-3"], isChecked: false, showsDetail: true)
]

final class TermTableView: BaseViewController {
    private let termTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termTableView.dataSource = self
        termTableView.delegate = self
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension TermTableView {
    private func attributes() {
        termTableView.register(TermHeaderView.self, forHeaderFooterViewReuseIdentifier: TermHeaderView.identifier)
        termTableView.register(TermCellView.self, forCellReuseIdentifier: TermCellView.identifier)
        termTableView.separatorStyle = .none
    }
    
    private func layout() {
        view.addSubview(termTableView)
        termTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            termTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            termTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            termTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
    }
}

// MARK: - DataSource
extension TermTableView: UITableViewDataSource {
    /// UITableView Reference : https://inuplace.tistory.com/1174
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Terms[section].details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermCellView.identifier, for: indexPath) as! TermCellView
        let text = Terms[indexPath.section].details[indexPath.row]
        cell.termLabel.text = text
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Terms.count
    }
}

// MARK: - Delegate
extension TermTableView: UITableViewDelegate {
    /// Custom Header Reference : https://velog.io/@minni/Custom-TableViewHeaderView-생성하기
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let termHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TermHeaderView.identifier) as? TermHeaderView else { return UIView() }
        let currentTerm = Terms[section]
        termHeaderView.checkButton.setImage(UIImage(systemName: currentTerm.isChecked ? "circle" : "checkmark.circle.fill"), for: .normal)
        termHeaderView.checkButton.tintColor = .designSystem(currentTerm.isChecked ? .gray2 : .mainBlue)
        termHeaderView.titleLabel.text = currentTerm.title
        termHeaderView.showDetailButton.setImage(UIImage(systemName: currentTerm.showsDetail ? "chevron.up" : "chevron.down"), for: .normal)
        return termHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}
