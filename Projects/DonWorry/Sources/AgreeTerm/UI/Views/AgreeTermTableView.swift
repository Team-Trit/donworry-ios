//
//  AgreeTermTableView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

var terms: [Term] = [
    Term(label: "전체동의"),
    Term(label: "만 14세 이상입니다.", children: [
        Term(label: "1-1"),
        Term(label: "1-2")
    ]),
    Term(label: "돈워리 서비스 이용약관 동의", children: [
        Term(label: "2-1"),
        Term(label: "2-2")
    ]),
    Term(label: "돈워리의 개인정보 수집 및 이용에 동의", children: [
        Term(label: "3-1")
    ]),
    Term(label: "돈워리 개인정보 제 3자 제공 동의"),
    Term(label: "이벤트 알림 수신 동의")
]

final class AgreeTermTableView: UITableView {
    var expandedSections = Set<Int>()
    
    init() {
        super.init(frame: .zero, style: .grouped)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension AgreeTermTableView {
    private func configure() {
        self.dataSource = self
        self.delegate = self
        self.register(AgreeTermTableViewHeader.self, forHeaderFooterViewReuseIdentifier: AgreeTermTableViewHeader.identifier)
        self.register(AgreeTermTableViewCell.self, forCellReuseIdentifier: AgreeTermTableViewCell.identifier)
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.allowsSelection = false
    }
}

// MARK: - UITableViewDataSource
extension AgreeTermTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgreeTermTableViewCell.identifier, for: indexPath) as! AgreeTermTableViewCell
        guard let children = terms[indexPath.section].children else { return cell }
        cell.termLabel.text = children[indexPath.row].label
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section), let children = terms[section].children {
            return children.count
        }
        return 0
    }
}

// MARK: - UITalbeViewDelegate
extension AgreeTermTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AgreeTermTableViewHeader.identifier) as! AgreeTermTableViewHeader
        header.titleLabel.text = terms[section].label
        if terms[section].children != nil {
            header.isExpanded = true
            header.showDetailButton?.tag = section
        }
        header.delegate = self
        header.checkButton.tag = section
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - AgreeTermTableViewHeaderDelegate
extension AgreeTermTableView: AgreeTermTableViewHeaderDelegate {
    func toggleCheck(_ sender: UIButton) {
        let section = sender.tag
        terms[section].isChecked.toggle()
        let isChecked = terms[section].isChecked
        
        if let header = self.headerView(forSection: sender.tag) as? AgreeTermTableViewHeader {
            UIView.animate(withDuration: 0.1) { [self] in
                self.performBatchUpdates {
                    header.checkButton.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
                    header.checkButton.tintColor = .designSystem(isChecked ? .mainBlue : .grayC5C5C5)
                }
            }
        }
    }
    
    func toggleAllCheck(_ sender: UIButton) {
        let isAllSatisfied = terms.allSatisfy { $0.isChecked }
        
        for i in 0..<terms.count {
            if let header = self.headerView(forSection: i) as? AgreeTermTableViewHeader {
                if isAllSatisfied {
                    terms[i].isChecked = false
                    UIView.animate(withDuration: 0.1) { [self] in
                        self.performBatchUpdates {
                            header.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            header.checkButton.tintColor = .designSystem(.grayC5C5C5)
                        }
                    }
                } else {
                    terms[i].isChecked = true
                    UIView.animate(withDuration: 0.1) { [self] in
                        self.performBatchUpdates {
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
        terms[section].isExpanded.toggle()
        let isExpanded = terms[section].isExpanded
        
        if let header = self.headerView(forSection: sender.tag) as? AgreeTermTableViewHeader {
            self.performBatchUpdates {
                header.showDetailButton!.rotate(isExpanded ? .pi : 0.0)
            }
        }
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            if let children = terms[section].children {
                for row in 0..<children.count {
                    indexPaths.append(IndexPath(row: row, section: section))
                }
            }
            return indexPaths
        }
        
        if expandedSections.contains(section) {
            expandedSections.remove(section)
            self.deleteRows(at: indexPathsForSection(), with: .fade)
        } else {
            expandedSections.insert(section)
            self.insertRows(at: indexPathsForSection(), with: .fade)
        }
    }
}

