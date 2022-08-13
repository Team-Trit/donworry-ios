//
//  AgreeTermViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/13.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import RxCocoa
import RxSwift

final class AgreeTermViewController: BaseViewController {
    private lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "돈워리 이용을 위해\n약관에 동의해 주세요."
        v.numberOfLines = 0
        v.font = .systemFont(ofSize: 18, weight: .bold)
        return v
    }()
    private lazy var termTableView: AgreeTermTableView = {
        let v = AgreeTermTableView()
        v.dataSource = self
        v.delegate = self
        v.register(TermTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TermTableViewHeaderView.identifier)
        v.register(TermTableViewCell.self, forCellReuseIdentifier: TermTableViewCell.identifier)
        v.backgroundColor = .white
        v.separatorStyle = .none
        v.showsVerticalScrollIndicator = false
        v.allowsSelection = false
        return v
    }()
    private lazy var doneButton: LargeButton = {
        let v = LargeButton(type: .done)
        v.delegate = self
        return v
    }()
    let viewModel = AgreeTermViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Layout
extension AgreeTermViewController {
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(descriptionLabel)
        view.addSubview(termTableView)
        view.addSubview(doneButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        termTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(250)
            make.bottom.equalToSuperview().offset(-200)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - TableViewDataSource
extension AgreeTermViewController: UITableViewDataSource {
    /// UITableView Reference : https://inuplace.tistory.com/1174
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms[section].details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermTableViewCell.identifier, for: indexPath) as! TermTableViewCell
        let text = terms[indexPath.section].details[indexPath.row]
        cell.termLabel.text = text
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return terms.count
    }
}

// MARK: - TableViewDelegate
extension AgreeTermViewController: UITableViewDelegate {
    /// Custom Header Reference : https://velog.io/@minni/Custom-TableViewHeaderView-생성하기
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let termHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TermTableViewHeaderView.identifier) as? TermTableViewHeaderView else { return UIView() }
        let currentTerm = terms[section]
        termHeaderView.delegate = self
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

// MARK: - TermHeaderViewDelegate
extension AgreeTermViewController: TermHeaderViewDelegate {
    func toggleCheck(_ sender: UIButton) {
        // TODO: Toggle isChecked
    }
    
    func showDetail(_ sender: UIButton) {
        // TODO: Toggle showsDetail and show detail terms
    }
}

// MARK: - LargeButtonDelegate {
extension AgreeTermViewController: LargeButtonDelegate {
    func buttonPressed(_ sender: UIButton) {
        present(TermConfirmViewController(), animated: true)
    }
}
