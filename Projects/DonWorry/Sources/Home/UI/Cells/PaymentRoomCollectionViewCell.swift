//
//  PaymentRoomCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import DonWorryExtensions

struct PaymentRoomCellViewModel {
    var title: String
}

final class PaymentRoomCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "PaymentRoomCollectionViewCell"

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.font = .designSystem(weight: .bold, size: ._13)
        v.textAlignment = .center
        return v
    }()

    var viewModel: PaymentRoomCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = viewModel.title
//                let textColor: UIColor? = viewModel.isSelect ? .designSystem(.white) : .designSystem(.black)
//                self?.titleLabel.textColor = textColor
//                if viewModel.isSelect {
//                    self?.contentView.addGradient(
//                        startColor: .designSystem(.blueTopGradient)!,
//                        endColor: .designSystem(.blueBottomGradient)!
//                    )
//                }
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
        self.contentView.roundCorners(self.contentView.bounds.width / 2)
        self.contentView.backgroundColor = .designSystem(.grayF6F6F6)
        self.contentView.addSubview(self.titleLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(20)
        }
    }
}
