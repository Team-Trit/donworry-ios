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

struct HomeHeaderViewModel {
    var imageURL: String
    var nickName: String
}

final class HomeHeaderView: UIView {

    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 15
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()

    lazy var profileImageView: UIImageView = {
        let v = UIImageView()
        v.image = .init(.test_avo)
        v.contentMode = .scaleAspectFill
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView)))
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
        v.setImage(UIImage(.icon_alarm), for: .normal)
        v.addTarget(self, action: #selector(didTapAlarmButton), for: .touchUpInside)
        return v
    }()

    var viewModel: HomeHeaderViewModel? {
        didSet {
            self.titleLabel.text = "\(viewModel?.nickName ?? "")님 안녕하세요"
            if let viewModel = viewModel {
                let url = URL(string: viewModel.imageURL)
                self.profileImageView.kf.setImage(with: url)
            }
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
        self.stackView.addArrangedSubview(self.profileImageView)
        self.stackView.addArrangedSubview(self.titleLabel)

        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalToSuperview()
        }
        self.profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        self.alarmButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileImageView)
            make.trailing.equalToSuperview().inset(25)
            make.width.height.equalTo(44)
        }
        self.alarmButton.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
        self.profileImageView.roundCorners(25)
    }

    @objc
    private func didTapProfileImageView() {
        print("didTapProfileImageView")
    }

    @objc
    private func didTapAlarmButton() {
        print("didTapAlarmButton")
    }

}


