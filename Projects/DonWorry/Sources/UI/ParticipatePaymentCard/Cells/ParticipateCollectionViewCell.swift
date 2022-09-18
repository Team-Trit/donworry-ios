//
//  ParticipateCollectionViewCell.swift
//  dondon
//
//  Created by Hankyu Lee on 2022/08/24.
//

import UIKit

import DesignSystem
import DonWorryExtensions
import RxSwift
import SnapKit

struct ParticipateCellViewModel: Equatable {
    let id: Int
    var isSelected: Bool
    let name: String
    let categoryName: String
    let amount: String
    let payer: ParticipateCellUser
    let date: String
    let bgColor: String

    static func == (lhs: ParticipateCellViewModel, rhs: ParticipateCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    struct ParticipateCellUser {
        let id: Int
        let imgURL: String?
        let name: String
    }
}

class ParticipateCollectionViewCell: UICollectionViewCell {
    static let cellID = "ParticipateCollectionViewCellID"
    var disposeBag = DisposeBag()
    private lazy var boundsWidth = contentView.bounds.width

    var viewModel: ParticipateCellViewModel? {
        didSet {
            participateCardView.titleLabel.text = viewModel?.name
            participateCardView.totalPriceLabel.text = viewModel?.amount
            participateCardView.userImageView.setBasicProfileImageWhenNilAndEmpty(with: viewModel?.payer.imgURL)
            participateCardView.iconImageView.image = UIImage(assetName: viewModel?.categoryName ?? "")
            participateCardView.userNicknameLabel.text = viewModel?.payer.name
            let bgColor = viewModel?.bgColor ?? ""
            participateCardView.leftCardView.backgroundColor = UIColor(hex: bgColor)?.withAlphaComponent(0.72)
            participateCardView.rightCardView.backgroundColor = UIColor(hex: bgColor)
            participateCardView.dateLabel.text = viewModel?.date ?? ""
            participateCardView.dateLabel.textColor = UIColor(hex: bgColor)
        }
    }
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setWidth(width: 42)
        button.setHeight(height: 42)
        button.roundCorners(21)
        button.backgroundColor = .designSystem(.grayF6F6F6)
        button.contentMode = .scaleAspectFit
        return button
    }()
    let participateCardView = ParticipateCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set UI
extension ParticipateCollectionViewCell {
    private func setUI() {
        self.addSubviews(checkButton, participateCardView)
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        participateCardView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
