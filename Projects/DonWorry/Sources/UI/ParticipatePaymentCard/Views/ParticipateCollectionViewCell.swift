//
//  ParticipateCollectionViewCell.swift
//  dondon
//
//  Created by Hankyu Lee on 2022/08/24.
//
import UIKit

import DesignSystem
import DonWorryExtensions
import Models


class ParticipateCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ParticipateCollectionViewCellID"
    fileprivate lazy var boundsWidth = contentView.bounds.width
    weak var delegate: CellCheckPress?
    
    var isChecked: Bool = false {
        willSet {
            checkButton.setImage(newValue ? UIImage(.check_gradient_image) : nil , for: .normal)
        }
    }
    
    var paymentCard: PaymentCard? {
        didSet {
            guard let paymentCard = paymentCard else {
                return
            }
            
            cardNameLabel.text = paymentCard.name
            
            switch paymentCard.cardIcon {
            case .chicken:
                iconImageView.image = UIImage(named: "chicken")
            default:
                iconImageView.image = UIImage(named: "chicken")
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let totalString = numberFormatter.string(from: NSNumber(value: paymentCard.totalAmount)) ?? ""
            
            totalPriceLabel.text = "총 \(totalString)원"
            if let url = URL(string: paymentCard.payer.image) {
                userImageView.load(url: url)
                
            }
            userNickNameLabel.text = paymentCard.payer.nickName
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd"
            dateformatter.locale = Locale(identifier: "ko_KR")
            
            dateLabel.text = dateformatter.string(from: paymentCard.date)
            cardLeftView.backgroundColor = UIColor(hex: paymentCard.backgroundColor + "FF")?.withAlphaComponent(0.72)
            cardRightView.backgroundColor = UIColor(hex: paymentCard.backgroundColor + "FF")
            dateLabel.textColor = UIColor(hex: paymentCard.backgroundColor + "FF")
            dateLabelContainer.backgroundColor = .designSystem(.grayF6F6F6)?.withAlphaComponent(0.80)
        }
    }

    fileprivate var checkButton: UIButton = {
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
        return label
    }()
    
    fileprivate let dateLabelContainer: UIView = {
        let view = UIView()
        view.roundCorners(11)
        view.setWidth(width: 40)
        view.setHeight(height: 24)
        view.backgroundColor = .black
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
        imageContainerView.anchor(top: cardNameLabel.bottomAnchor, left: cardLeftView.leftAnchor, paddingTop: 11, paddingLeft: 18)
        
        cardLeftView.addSubview(totalPriceLabel)
        totalPriceLabel.anchor(top: cardNameLabel.bottomAnchor, left: imageContainerView.rightAnchor, right: cardLeftView.rightAnchor, paddingTop: 14, paddingLeft: 6, paddingRight: 8)
        
        cardRightView.addSubview(userImageView)
        userImageView.centerX(inView: cardRightView)
        userImageView.centerY(inView: cardNameLabel)
        
        cardRightView.addSubview(userNickNameLabel)
        userNickNameLabel.anchor(top: userImageView.bottomAnchor, paddingTop: 5)
        userNickNameLabel.centerX(inView: userImageView)
        
        dateLabelContainer.addSubview(dateLabel)
        dateLabel.centerX(inView: dateLabelContainer)
        dateLabel.centerY(inView: dateLabelContainer)
        
        cardRightView.addSubview(dateLabelContainer)
        dateLabelContainer.anchor(top: userNickNameLabel.bottomAnchor, paddingTop: 18)
        dateLabelContainer.centerX(inView: userImageView)
    }
    
    @objc fileprivate func toggleCheck() {
        guard let paymentCard = paymentCard else {
            return
        }
        delegate?.toggleCheckAt(paymentCard.id)
    }
}

protocol CellCheckPress: AnyObject {
    func toggleCheckAt(_ id: Int)
}

