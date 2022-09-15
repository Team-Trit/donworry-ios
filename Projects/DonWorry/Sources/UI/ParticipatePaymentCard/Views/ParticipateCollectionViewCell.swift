//
//  ParticipateCollectionViewCell.swift
//  dondon
//
//  Created by Hankyu Lee on 2022/08/24.
//
import UIKit

import DesignSystem
import DonWorryExtensions

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

protocol ParticipateCellDelegate: AnyObject {
    func toggleCheckAt(_ viewModel: ParticipateCellViewModel)
}

class ParticipateCollectionViewCell: UICollectionViewCell {
    static let cellID = "ParticipateCollectionViewCellID"
    fileprivate lazy var boundsWidth = contentView.bounds.width
    weak var delegate: ParticipateCellDelegate?

    var viewModel: ParticipateCellViewModel? {
        didSet {
            cardNameLabel.text = viewModel?.name

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let viewModel = viewModel {
                totalPriceLabel.text = "\(viewModel.amount)"
            } else {
                totalPriceLabel.text = "총 0원"
            }
            userImageView.setBasicProfileImageWhenNilAndEmpty(with: viewModel?.payer.imgURL)
            iconImageView.image =  UIImage(assetName: viewModel?.categoryName ?? "")
            userNickNameLabel.text = viewModel?.payer.name
            
            let bgColor = viewModel?.bgColor ?? ""
            cardLeftView.backgroundColor = UIColor(hex: bgColor)?.withAlphaComponent(0.72)
            cardRightView.backgroundColor = UIColor(hex: bgColor)

            dateLabel.text = viewModel?.date ?? ""
            dateLabel.textColor = UIColor(hex: bgColor)
            isChecked = viewModel?.isSelected ?? false
        }
    }
    var isChecked: Bool = false {
        willSet {
            checkButton.setImage(newValue ? UIImage(.check_gradient_image) : nil , for: .normal)
        }
    }
    
    fileprivate lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setWidth(width: 42)
        button.setHeight(height: 42)
        button.roundCorners(21)
        button.backgroundColor = .designSystem(.grayF6F6F6)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        return button
    }()
    
    fileprivate let wrappedCardTotalView :UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addShadowWithRoundedCorners(20.0, shadowColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.5), opacity: 1)
        return view
    }()
        
    fileprivate let cardTotalView :UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.roundCorners(20)
        return view
    }()
    
    fileprivate let cardLeftView: UIView = {
        let view = UIView()
        view.roundCorners(20)
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    fileprivate let cardRightView: UIView = {
        let view = UIView()
        view.roundCorners(20)
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    fileprivate let cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.textColor = .white
        return label
    }()
    
    fileprivate let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setWidth(width: 28)
        imageView.setHeight(height: 28)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners(5)
        view.setHeight(height: 33)
        view.setWidth(width: 33)
        return view
    }()
    
    fileprivate let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .designSystem(weight: .heavy, size: ._20)
        return label
    }()
    
    fileprivate let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setWidth(width: 25)
        imageView.setHeight(height: 25)
        imageView.roundCorners(12.5)
        imageView.contentMode = .scaleToFill //
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let userNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._13)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let dateLabelContainer: UIView = {
        let view = UIView()
        view.roundCorners(11)
        view.setWidth(width: 40)
        view.setHeight(height: 24)
        view.backgroundColor = .designSystem(.grayF6F6F6)?.withAlphaComponent(0.80)
        return view
    }()
    
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._9)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
    
    fileprivate func setUI() {
        let hstack = UIStackView(arrangedSubviews: [checkButton, wrappedCardTotalView])
        hstack.spacing = 17
        hstack.alignment = .center
        contentView.addSubview(hstack)
        wrappedCardTotalView.addSubview(cardTotalView)
        cardTotalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hstack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        wrappedCardTotalView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, right: hstack.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0, width: boundsWidth * 281 / 340)
        
        cardTotalView.addSubview(cardRightView)
        cardRightView.anchor(top: cardTotalView.topAnchor, bottom: cardTotalView.bottomAnchor, right: cardTotalView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0, width: boundsWidth * 69 / 340)
        
        cardTotalView.addSubview(cardLeftView)
        cardLeftView.anchor(top: cardTotalView.topAnchor, left: cardTotalView.leftAnchor,bottom: cardTotalView.bottomAnchor,right: cardRightView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        cardLeftView.addSubview(cardNameLabel)
        cardNameLabel.anchor(top: cardLeftView.topAnchor, left: cardLeftView.leftAnchor, right: cardLeftView.rightAnchor, paddingTop: 24, paddingLeft: 21, paddingRight: 8)
        
        imageContainerView.addSubview(iconImageView)
        iconImageView.centerY(inView: imageContainerView)
        iconImageView.centerX(inView: imageContainerView)
        
        cardLeftView.addSubview(imageContainerView)
        imageContainerView.anchor(left: cardLeftView.leftAnchor, paddingLeft: 18)
        imageContainerView.centerY(inView: contentView)
        
        cardLeftView.addSubview(totalPriceLabel)
        
        totalPriceLabel.centerY(inView: contentView)
        totalPriceLabel.anchor(left: imageContainerView.rightAnchor, right: cardLeftView.rightAnchor, paddingLeft: 6, paddingRight: 8)
        
        cardRightView.addSubview(userImageView)
        userImageView.centerX(inView: cardRightView)
        userImageView.centerY(inView: cardNameLabel)
        
        cardRightView.addSubview(userNickNameLabel)
        userNickNameLabel.anchor(top: userImageView.bottomAnchor, paddingTop: 5)
        userNickNameLabel.anchor(left: cardRightView.leftAnchor, right: cardRightView.rightAnchor, paddingLeft: 4, paddingRight: 4)
        
        dateLabelContainer.addSubview(dateLabel)
        dateLabel.centerX(inView: dateLabelContainer)
        dateLabel.centerY(inView: dateLabelContainer)
        
        cardRightView.addSubview(dateLabelContainer)
        dateLabelContainer.anchor(bottom: cardRightView.bottomAnchor, paddingBottom: 24)
        dateLabelContainer.centerX(inView: userImageView)
    }
    
    @objc fileprivate func toggleCheck() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.toggleCheckAt(viewModel)
    }
}
