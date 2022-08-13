//
//  TermTableViewHeaderView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

protocol TermTableViewHeaderViewDelegate: AnyObject {
    func toggleCheck(_ sender: UIButton)
    func showDetail(_ sender: UIButton)
}

final class TermTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = "TermTableViewHeaderView"
    private lazy var termStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 20
        v.alignment = .center
        return v
    }()
    lazy var checkButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        return v
    }()
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.gray1)
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    lazy var showDetailButton: UIButton = {
        let v = UIButton()
        v.tintColor = .designSystem(.gray1)
        v.addTarget(self, action: #selector(showDetailButtonPressed(_:)), for: .touchUpInside)
        return v
    }()
    weak var delegate: TermTableViewHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension TermTableViewHeaderView {
    private func setUI() {
        contentView.backgroundColor = .white
        termStackView.addArrangedSubview(checkButton)
        termStackView.addArrangedSubview(titleLabel)
        termStackView.addArrangedSubview(showDetailButton)
        contentView.addSubview(termStackView)
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        termStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
    }
}

// MARK: - Interaction Functions
extension TermTableViewHeaderView {
    @objc private func checkButtonPressed(_ sender: UIButton) {
        delegate?.toggleCheck(sender)
    }
    
    @objc private func showDetailButtonPressed(_ sender: UIButton) {
        delegate?.showDetail(sender)
    }
}
