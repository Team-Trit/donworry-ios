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
    var cardIconImageName: String
    var payer: User
    var participatedUserList: [User]
    var dateString: String
    var backgroundColor: String
    var yetCompleted: Bool

    struct User: Equatable {
        var id: Int
        var nickName: String
        var imageURL: String
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
            self.paymentCardInRoomView.viewModel = viewModel.map { model in
                return PaymentCardInRoomViewModel(
                    id: model.id,
                    name: model.name,
                    cardIconImageName: model.cardIconImageName,
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
            self.completeCoverView.isHidden = (viewModel?.yetCompleted ?? false)
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

        self.layer.borderColor = UIColor.designSystem(.white)?.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 20
        self.addShadow(
            shadowColor: UIColor.designSystem(.black)!.cgColor,
            offset: .init(width: 0, height: 2),
            opacity: 0.5,
            radius: 2
        )
        self.contentView.addSubview(self.paymentCardInRoomView)
        self.contentView.addSubview(self.completeCoverView)

        self.paymentCardInRoomView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.completeCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.paymentCardInRoomView.layer.masksToBounds = true
        self.completeCoverView.roundCorners(20)
        self.addCompleteCoverViewBlurEffect()
    }

    private func addCompleteCoverViewBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = completeCoverView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addCompleteCheckImageView(to: blurEffectView)
        self.completeCoverView.addSubview(blurEffectView)
    }

    private func addCompleteCheckImageView(to superView: UIVisualEffectView) {
        let checkImageView = UIImageView(image: .init(.ic_check_white))
        superView.contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
}
