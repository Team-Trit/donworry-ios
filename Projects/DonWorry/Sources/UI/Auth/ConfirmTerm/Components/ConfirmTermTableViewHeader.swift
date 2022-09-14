//
//  ConfirmTermTableViewHeader.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import DonWorryExtensions
import SnapKit

final class ConfirmTermTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "ConfirmTermTableViewHeader"
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "\(Date().formatted("yyyy년 M월 dd일")) 아래 약관에 동의합니다."
        v.font = .designSystem(weight: .bold, size: ._18)
        v.numberOfLines = 0
        return v
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension ConfirmTermTableViewHeader {
    private func setUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(25)
        }
    }
}
