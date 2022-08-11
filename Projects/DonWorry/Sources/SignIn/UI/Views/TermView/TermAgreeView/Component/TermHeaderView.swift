//
//  TermHeaderView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

protocol TermHeaderViewDelegate: AnyObject {
    func toggleCheck(_ sender: UIButton)
    func showDetail(_ sender: UIButton)
}

final class TermHeaderView: UITableViewHeaderFooterView {
    static let identifier = "TermHeaderView"
    private var horizontalStackView = UIStackView()
    var checkButton = UIButton()
    var titleLabel = UILabel()
    var showDetailButton = UIButton()
    weak var delegate: TermHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        attributes()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension TermHeaderView {
    private func attributes() {
        checkButton.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        setTitleLabel()
        setShowDetailButton()
        setHorizontalStackView()
    }
    
    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 230).isActive = true
        horizontalStackView.addArrangedSubview(checkButton)
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(showDetailButton)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 24),
            horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Attributes Helper
    private func setTitleLabel() {
        titleLabel.textColor = .designSystem(.gray1)
        titleLabel.font = .systemFont(ofSize: 15)
    }
    
    private func setShowDetailButton() {
        showDetailButton.tintColor = .designSystem(.gray1)
        showDetailButton.addTarget(self, action: #selector(showDetailButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setHorizontalStackView() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 20
        horizontalStackView.alignment = .center
    }
}

// MARK: - Interaction Functions
extension TermHeaderView {
    @objc private func checkButtonPressed(_ sender: UIButton) {
        delegate?.toggleCheck(sender)
    }
    
    @objc private func showDetailButtonPressed(_ sender: UIButton) {
        delegate?.showDetail(sender)
    }
}
