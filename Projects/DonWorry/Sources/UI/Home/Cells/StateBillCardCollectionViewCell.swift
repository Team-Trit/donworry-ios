//
//  StateBillCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions

struct StateBillCardViewModel: Equatable {
    var status: StateBillCardCollectionViewCell.SpaceStatus
}
final class StateBillCardCollectionViewCell: UICollectionViewCell {

    enum SpaceStatus {
        case open
        case progress
        case done
        case close
    }

    lazy var imageView: UIImageView = {
        let v = UIImageView()

        return v
    }()
    lazy var periodLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._30)
        v.textColor = .designSystem(.white)
        v.text = "•••"
        return v
    }()

    lazy var circleView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.grayF6F6F6)
        v.alpha = 0.51
        return v
    }()

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._15)
        v.textColor = .designSystem(.white)
        return v
    }()

    var viewModel: StateBillCardViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            titleLabel.text = self.setTitle(by: viewModel.status)
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
        self.contentView.addSubview(self.circleView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.periodLabel)

        self.circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(83)
        }
        self.periodLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(19.5)
            make.centerX.equalToSuperview()
        }

        self.circleView.roundCorners(83/2)
        self.contentView.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
    }

    private func setTitle(by status: SpaceStatus) -> String {
        switch status {
        case .open:
            return "참석확인 중"
        case .progress:
            return "정산 내역 보기"
        case .done:
            return "정산 완료"
        case .close:
            return ""
        }
    }

//    private func setImage(by status: SpaceStatus) -> UIImage {
//
//    }
}
