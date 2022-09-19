//
//  TakeBillCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions

struct TakeBillCardCellViewModel: Equatable {
    var userCount: Int
    var totalCount: Int
    var amount: String
    var isCompleted: Bool
}

final class TakeBillCardCollectionViewCell: UICollectionViewCell {

    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .bold, size: ._13)
        v.textColor = .designSystem(.white)
        v.text = "미정산:"
        return v
    }()
    lazy var amountLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.white)
        v.font = .designSystem(weight: .heavy, size: ._20)
        v.textAlignment = .center
        return v
    }()
    lazy var statusImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(.ic_billcard_ing)
        return v
    }()

    var viewModel: TakeBillCardCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.descriptionLabel.text = "미정산: \(viewModel.userCount) / \(viewModel.totalCount)"
            self.amountLabel.text = viewModel.amount
            if viewModel.isCompleted { self.addCompleteView() }
            else { self.removeCompleteView() }
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
        self.contentView.backgroundColor = .designSystem(.green)
        self.contentView.addSubview(self.statusImageView)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.amountLabel)

        self.statusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(84)
        }
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        self.amountLabel.snp.makeConstraints { make in
            make.top.equalTo(statusImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        self.statusImageView.roundCorners(42)
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
    }
}
