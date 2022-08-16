//
//  LabelStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class LabelStackView: UIStackView {
    private lazy var labelStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        v.alignment = .center
        return v
    }()
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "돈.워리"
        v.font = .gmarksans(weight: .bold, size: ._30)
        v.textColor = .designSystem(.mainBlue)
        return v
    }()
    private lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textAlignment = .center
        v.text = "떼인 돈 받아드립니다.\n걱정마세요."
        v.font = .gmarksans(weight: .light, size: ._15)
        return v
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
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
