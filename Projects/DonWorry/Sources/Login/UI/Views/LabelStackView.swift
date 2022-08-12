//
//  LabelStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class LabelStackView: UIStackView {
    private lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.axis = .vertical
        labelStackView.spacing = 20
        labelStackView.alignment = .center
        return labelStackView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "돈.워리"
        titleLabel.font = .gmarksans(weight: .bold, size: ._30)
        titleLabel.textColor = .designSystem(.mainBlue)
        return titleLabel
    }()
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "떼인 돈 받아드립니다.\n걱정마세요."
        descriptionLabel.font = .gmarksans(weight: .light, size: ._15)
        return descriptionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension LabelStackView {
    private func setUI() {
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
    }
}
