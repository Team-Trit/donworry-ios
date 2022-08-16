//
//  PaymentCard.swift
//  DesignSystem
//
//  Created by Chanhee Jeong on 2022/08/09.
//  Updated by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import SnapKit
import DesignSystem
import DonWorryExtensions
import Kingfisher

struct PaymentCardInRoomViewModel {
    var id: Int
    var name: String
    var cardIconImageName: String
    var totalAmount: String
    var backgroundColor: String
    var date: String
    var payer: PaymentCardCellDdipUser
    var participatedUserList: [PaymentCardCellDdipUser]
}

public class PaymentCardInRoomView: UIView {

    var viewModel: PaymentCardInRoomViewModel? {
        didSet {
            self.nameLabel.text = viewModel?.name
            self.totalAmountLabel.text = "\(viewModel?.totalAmount ?? "")"
            self.dateLabel.text = viewModel?.date
            let participatedUserCount = "\(viewModel?.participatedUserList.count ?? 0)"
            self.participatedUserCountLabel.text = "현재 \(participatedUserCount)명 참가 중 …"
            self.iconImageView.image = UIImage(named: viewModel?.cardIconImageName ?? "")
            let backgroundColor = UIColor(hex: (viewModel?.backgroundColor ?? "") + "FF")
            self.backgroundColor = backgroundColor?.withAlphaComponent(0.72)
            self.cardSideView.backgroundColor = backgroundColor
            self.dateLabel.textColor = backgroundColor
            self.payerNameLabel.text = viewModel?.payer.nickName
            if let urlString = viewModel?.payer.imageURL {
                let url = URL(string: urlString)
                payerImageView.kf.setImage(with: url)
            }
            self.drawParticipatedUser(viewModel?.participatedUserList ?? [])
        }
    }

    private func drawParticipatedUser(_ users: [PaymentCardCellDdipUser]) {
        participatedUserView.subviews.forEach { $0.removeFromSuperview() }
        let imageViews = users.prefix(4).map { (user: PaymentCardCellDdipUser) -> UIImageView in
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: user.imageURL))
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        var offset: Int = 0
        imageViews.forEach { [weak self] in
            self?.participatedUserView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(offset)
            }
            $0.roundCorners(12)
            offset += 17
        }

        if users.count > 4 {
            let imageView = UIImageView(image: .init(systemName: "ellipsis.circle.fill"))
            imageView.tintColor = .designSystem(.white2)
            participatedUserView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(offset)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let nameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    private let amountStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 7
        v.alignment = .center
        v.distribution = .fill
        return v
    }()
    private let iconWrappedView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.white)
        return v
    }()
    private let iconImageView: UIImageView = {
        $0.image = UIImage(named: "chicken")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .designSystem(.white)
        return $0
    }(UIImageView())
    private let totalAmountLabel: UILabel = {
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    private let participatedUserCountLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.white)
        v.font = .designSystem(weight: .light, size: ._13)
        return v
    }()
    private let cardSideView = UIView()
    private let payerStackView: UIStackView = {
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        return $0
    }(UIStackView())
    private let payerImageView: UIImageView = {
        $0.image = UIImage(named: "profile-sample")
        $0.contentMode = .scaleAspectFill
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    private let payerNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "정산자"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    private let participatedUserView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    private let dateLabel: UILabel = {
        $0.font = .designSystem(weight: .bold, size: ._9)
        $0.backgroundColor = .designSystem(.white)?.withAlphaComponent(0.48)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())
}

extension PaymentCardInRoomView {

    func setUI() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.amountStackView)
        self.addSubview(self.cardSideView)
        self.addSubview(self.participatedUserCountLabel)
        self.amountStackView.addArrangedSubview(self.iconWrappedView)
        self.amountStackView.addArrangedSubview(self.totalAmountLabel)
        self.iconWrappedView.addSubview(self.iconImageView)
        self.cardSideView.addSubview(self.participatedUserView)
        self.cardSideView.addSubview(self.payerStackView)
        self.cardSideView.addSubview(self.dateLabel)
        self.payerStackView.addArrangedSubview(self.payerImageView)
        self.payerStackView.addArrangedSubview(self.payerNameLabel)

        self.snp.makeConstraints { make in
            make.width.equalTo(340)
            make.height.equalTo(216)
        }
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(20)
        }
        self.amountStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        self.iconWrappedView.snp.makeConstraints { make in
            make.width.height.equalTo(37)
        }
        self.iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        self.participatedUserCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().inset(19)
            make.trailing.equalTo(self.cardSideView.snp.leading).inset(10)
        }
        self.cardSideView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(84)
        }
        self.payerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        self.participatedUserView.snp.makeConstraints { make in
            make.top.equalTo(self.payerStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.dateLabel.snp.top)
        }
        self.dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(payerStackView)
            make.width.equalTo(47)
            make.height.equalTo(24)
            make.bottom.equalToSuperview().inset(18)
        }
        self.payerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }

        self.roundCorners(20)
        self.iconWrappedView.roundCorners(5)
    }

}
