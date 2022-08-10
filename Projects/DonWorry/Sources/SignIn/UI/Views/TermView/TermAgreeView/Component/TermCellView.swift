//
//  TermCellView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class TermCellView: UITableViewCell {
    static let identifier = "TermCellView"
    var termLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attributes()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension TermCellView {
    private func attributes() {
        termLabel.textColor = .designSystem(.gray1)
        termLabel.font = .systemFont(ofSize: 15)
    }
    
    private func layout() {
        addSubview(termLabel)
        termLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            termLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            termLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 230)
        ])
    }
}