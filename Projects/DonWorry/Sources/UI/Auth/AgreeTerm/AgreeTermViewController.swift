//
//  AgreeTermViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/17.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class AgreeTermViewController: BaseViewController, View {
    private lazy var navigationBar = DWNavigationBar(title: "돈워리 이용약관")
    private lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "돈워리 이용을 위해\n약관에 동의해 주세요."
        v.font = .designSystem(weight: .bold, size: ._18)
        v.numberOfLines = 0
        return v
    }()
    private lazy var agreeTermTableView: AgreeTermTableView = {
        let v = AgreeTermTableView()
        v.dataSource = self
        v.delegate = self
        return v
    }()
    private lazy var doneButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "완료"
        v.isEnabled = false
        return v
    }()
    private var expandedSections = Set<Int>()
    private let viewModel = TermViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func bind(reactor: AgreeTermViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension AgreeTermViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, descriptionLabel, agreeTermTableView, doneButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        agreeTermTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-170)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(297)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Bind
extension AgreeTermViewController {
    private func dispatch(to reactor: AgreeTermViewReactor) {
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.backButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.doneButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: AgreeTermViewReactor) {
        
    }
}

// MARK: - UITableViewDataSource
extension AgreeTermViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgreeTermTableViewCell.identifier, for: indexPath) as! AgreeTermTableViewCell
        guard let children = viewModel.terms[indexPath.section].children else { return cell }
        cell.termLabel.text = children[indexPath.row].label
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section), let children = viewModel.terms[section].children {
            return children.count
        }
        return 0
    }
}

// MARK: - UITableViewDelegate
extension AgreeTermViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AgreeTermTableViewHeader.identifier) as! AgreeTermTableViewHeader
        header.titleLabel.text = viewModel.terms[section].label
        if viewModel.terms[section].children != nil {
            header.isExpanded = true
            header.showDetailButton?.tag = section
        }
        header.delegate = self
        header.checkButton.tag = section
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - AgreeTermTableViewHeaderDelegate
extension AgreeTermViewController: AgreeTermTableViewHeaderDelegate {
    func toggleCheck(_ sender: UIButton) {
        let section = sender.tag
        viewModel.terms[section].isChecked.toggle()
        let isChecked = viewModel.terms[section].isChecked
        
        if let header = agreeTermTableView.headerView(forSection: sender.tag) as? AgreeTermTableViewHeader {
            UIView.animate(withDuration: 0.1) { [self] in
                agreeTermTableView.performBatchUpdates {
                    header.checkButton.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
                    header.checkButton.tintColor = .designSystem(isChecked ? .mainBlue : .grayC5C5C5)
                }
            }
        }
    }
    
    func toggleAllCheck(_ sender: UIButton) {
        let isAllSatisfied = viewModel.terms.allSatisfy { $0.isChecked }
        
        for i in 0..<viewModel.terms.count {
            if let header = agreeTermTableView.headerView(forSection: i) as? AgreeTermTableViewHeader {
                if isAllSatisfied {
                    viewModel.terms[i].isChecked = false
                    UIView.animate(withDuration: 0.1) { [self] in
                        agreeTermTableView.performBatchUpdates {
                            header.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            header.checkButton.tintColor = .designSystem(.grayC5C5C5)
                        }
                    }
                } else {
                    viewModel.terms[i].isChecked = true
                    UIView.animate(withDuration: 0.1) { [self] in
                        agreeTermTableView.performBatchUpdates {
                            header.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                            header.checkButton.tintColor = .designSystem(.mainBlue)
                        }
                    }
                }
            }
        }
    }
    
    func showDetail(_ sender: UIButton) {
        let section = sender.tag
        viewModel.terms[section].isExpanded.toggle()
        let isExpanded = viewModel.terms[section].isExpanded
        
        if let header = agreeTermTableView.headerView(forSection: sender.tag) as? AgreeTermTableViewHeader {
            agreeTermTableView.performBatchUpdates {
                header.showDetailButton!.rotate(isExpanded ? .pi : 0.0)
            }
        }
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            if let children = viewModel.terms[section].children {
                for row in 0..<children.count {
                    indexPaths.append(IndexPath(row: row, section: section))
                }
            }
            return indexPaths
        }
        
        if expandedSections.contains(section) {
            expandedSections.remove(section)
            agreeTermTableView.deleteRows(at: indexPathsForSection(), with: .fade)
        } else {
            expandedSections.insert(section)
            agreeTermTableView.insertRows(at: indexPathsForSection(), with: .fade)
        }
    }
}
