//
//  NavigationBar.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions
import SnapKit

final class NavigationBar: UIView {

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._20)
        v.textColor = .designSystem(.black)
        return v
    }()

    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    lazy var optionButton: UIButton = {
        let v = UIButton(type: .system)
        let configure = UIImage.SymbolConfiguration.init(font: UIFont.boldSystemFont(ofSize: 15))
        v.setImage(UIImage(systemName: "ellipsis", withConfiguration: configure), for: .normal)
        v.tintColor = .designSystem(.black)
        return v
    }()

    var viewModel: HomeHeaderViewModel? {
        didSet {
            self.titleLabel.text = ""
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setUI()
    }

    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.optionButton)

        self.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        self.stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(25)
        }
        self.optionButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
}


