//
//  HomeHeaderView.swift
//  DonWorry
//
//  Created by Woody on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import SkeletonView

struct HomeHeaderViewModel {
    var imageURL: String?
    var nickName: String
}

final class HomeHeaderView: UIView {

    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 15
        v.distribution = .fill
        v.alignment = .center
        return v
    }()

    lazy var profileButton: UIButton = {
        let v = UIButton()
        v.setImage(.init(.test_avo), for: .normal)
        v.imageView?.contentMode = .scaleAspectFill
        return v
    }()

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._20)
        v.textColor = .designSystem(.black)
        return v
    }()

    lazy var alarmButton: UIButton = {
        let v = UIButton(type: .system)
        v.roundCorners(22)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 13, bottom: 13, right: 12)
        v.tintColor = .designSystem(.white)
        v.setImage(UIImage(.ic_alarm), for: .normal)
        return v
    }()

    var viewModel: HomeHeaderViewModel? {
        didSet {
            self.titleLabel.text = "\(viewModel?.nickName ?? "")님 안녕하세요"
            profileButton.setBasicProfileImageWhenNilAndEmpty(with: viewModel?.imageURL)
            profileButton.roundCorners(22.5)
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
        self.addSubview(self.stackView)
        self.addSubview(self.alarmButton)
        self.stackView.addArrangedSubview(self.profileButton)
        self.stackView.addArrangedSubview(self.titleLabel)

        commonAttribute(of: self)
        commonAttribute(of: stackView)
        commonAttribute(of: alarmButton)
        commonAttribute(of: profileButton)
        commonAttribute(of: titleLabel)

        self.snp.makeConstraints { make in
            make.height.equalTo(65)
        }
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalTo(alarmButton.snp.leading).offset(10)
            make.bottom.equalToSuperview()
        }
        self.profileButton.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }
        self.alarmButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileButton)
            make.trailing.equalToSuperview().inset(25)
            make.width.height.equalTo(44)
        }
        self.alarmButton.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
        self.profileButton.roundCorners(22.5)
    }

    private func commonAttribute(of target: UIView) {
        target.isSkeletonable = true
    }
}
