//
//  PaymentCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions

struct PaymentCardCellViewModel: Equatable {
    var id: Int
    var name: String
    var totalAmount: String
    var number: Int
    var categoryImageName: String
    var payer: User
    var participatedUserList: [User]
    var dateString: String
    var backgroundColor: String
    var isUserParticipated: Bool

    struct User: Equatable {
        var id: Int
        var nickName: String
        var imageURL: String?
    }
}

final class PaymentCardCollectionViewCell: UICollectionViewCell {
    lazy var paymentCardInRoomView = PaymentCardInRoomView()
    lazy var completeCoverView: UIView = {
        let v = UIView()
        return v
    }()

    var viewModel: PaymentCardCellViewModel? {
        didSet {
            self.isParticipated(viewModel?.isUserParticipated ?? false)
            self.paymentCardInRoomView.viewModel = viewModel.map { model in
                return PaymentCardInRoomViewModel(
                    id: model.id,
                    name: model.name,
                    categoryImageName: model.categoryImageName,
                    totalAmount: model.totalAmount,
                    backgroundColor: model.backgroundColor,
                    date: model.dateString,
                    payer: .init(
                        id: model.payer.id,
                        nickName: model.payer.nickName,
                        imageURL: model.payer.imageURL
                    ),
                    participatedUserList: model.participatedUserList.map {
                        .init(id: $0.id, nickName: $0.nickName, imageURL: $0.imageURL)
                    }
                )
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
        self.layer.cornerRadius = 20
        self.contentView.addSubview(self.paymentCardInRoomView)

        self.paymentCardInRoomView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.paymentCardInRoomView.layer.masksToBounds = true
    }

    private func isParticipated(_ direction: Bool?) {
        guard let direction = direction else { return }
        if direction {
            let imageView = UIImageView(image: UIImage(.ic_check_gradient))
            self.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.trailing.equalToSuperview().offset(9)
                make.top.equalToSuperview().offset(-9)
            }
        }
    }
}
