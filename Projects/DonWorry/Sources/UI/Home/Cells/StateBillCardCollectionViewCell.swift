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

    lazy var statusImageView: UIImageView = {
        let v = UIImageView()
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
            statusImageView.image = self.setImage(by: viewModel.status)
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
    
    override var isHighlighted: Bool {
        didSet {
            self.showAnimationOnHilighted()
        }
    }

    private func setUI() {
        self.contentView.addSubview(self.statusImageView)
        self.contentView.addSubview(self.titleLabel)

        self.statusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(84)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(statusImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        self.statusImageView.roundCorners(42)
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

    private func setImage(by status: SpaceStatus) -> UIImage? {
        switch status {
        case .open:
            return UIImage(.ic_billcard_ing)
        case .progress:
            return UIImage(.ic_billcard_ing)
        case .done:
            return UIImage(.ic_billcard_check)
        case .close:
            return UIImage(.ic_billcard_ing)
        }
    }
}
