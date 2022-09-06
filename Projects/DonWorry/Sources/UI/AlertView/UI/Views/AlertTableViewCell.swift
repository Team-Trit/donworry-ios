//
//  AlertTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class AlertTableViewCell: UITableViewCell {
    
    static let identifier: String = "AlertTableViewCell"
    
    let smallRectangele: UIView = {
        let smallRec = UIView()
        smallRec.translatesAutoresizingMaskIntoConstraints = false
        smallRec.roundCorners(15)
        smallRec.addShadowWithRoundedCorners()
        smallRec.backgroundColor = .designSystem(.white)
        return smallRec
    }()
    
    let iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        return iconImage
    }()
    
    let spaceName: UILabel = {
        let spaceName = UILabel()
        spaceName.translatesAutoresizingMaskIntoConstraints = false
        spaceName.font = .designSystem(weight: .heavy, size: ._15)
        spaceName.textColor = .designSystem(.black)
        return spaceName
    }()
    
    let alertInfo: UILabel = {
        let alertInfo = UILabel()
        alertInfo.translatesAutoresizingMaskIntoConstraints = false
        alertInfo.font = .designSystem(weight: .regular, size: ._13)
        alertInfo.textColor = .designSystem(.gray818181)
        return alertInfo
    }()
    
    private let goToPayment: UIImageView = {
        let goToPayment = UIImageView()
//        goToPayment.frame = CGRect(x: 300, y: 25, width: 72, height: 33)
        goToPayment.translatesAutoresizingMaskIntoConstraints = false
        goToPayment.backgroundColor = .designSystem(.mainBlue)
        goToPayment.layer.cornerRadius = 16.5
        goToPayment.isHidden = true
        return goToPayment
    }()
    
    private let buttonLabel: UILabel = {
        let buttonLabel = UILabel()
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.text = "정산하기"
        buttonLabel.font = .designSystem(weight: .bold, size: ._13)
        buttonLabel.textColor = .white
        return buttonLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        contentView.addSubview(smallRectangele)
        smallRectangele.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        smallRectangele.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        smallRectangele.widthAnchor.constraint(equalToConstant: 43).isActive = true
        smallRectangele.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        smallRectangele.addSubview(iconImage)
        iconImage.centerXAnchor.constraint(equalTo: smallRectangele.centerXAnchor).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: smallRectangele.centerYAnchor).isActive = true
        
        contentView.addSubview(spaceName)
        spaceName.topAnchor.constraint(equalTo: smallRectangele.topAnchor).isActive = true
        spaceName.leadingAnchor.constraint(equalTo: smallRectangele.trailingAnchor, constant: 10).isActive = true
        
        contentView.addSubview(alertInfo)
        alertInfo.bottomAnchor.constraint(equalTo: smallRectangele.bottomAnchor).isActive = true
        alertInfo.leadingAnchor.constraint(equalTo: smallRectangele.trailingAnchor, constant: 10).isActive = true
        
        contentView.addSubview(goToPayment)
        goToPayment.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        goToPayment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
        goToPayment.widthAnchor.constraint(equalToConstant: 72).isActive = true
        goToPayment.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        goToPayment.addSubview(buttonLabel)
        buttonLabel.centerYAnchor.constraint(equalTo: goToPayment.centerYAnchor).isActive = true
        buttonLabel.centerXAnchor.constraint(equalTo: goToPayment.centerXAnchor).isActive = true
    }
    
    func configure(message: AlertMessageInfomations){
        spaceName.text = message.spaceName
        
        switch message.messageType {
        case .startAlert :
            alertInfo.text = "\(message.senderName)님이 정산을 시작하셨습니다"
            smallRectangele.largeContentImage = UIImage(named: "startAlertImage")
            iconImage.image = UIImage(named: "startAlertImage")
            iconImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            iconImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        case .hurriedAlert :
            alertInfo.text = "\(message.senderName)님이 정산을 재촉하셨습니다"
            iconImage.image = UIImage(named: "hurriedAlertImage")
            iconImage.widthAnchor.constraint(equalToConstant: 37).isActive = true
            iconImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
            goToPayment.isHidden = false
            if message.isCompleted {
                goToPayment.backgroundColor = .designSystem(.grayC5C5C5)
                buttonLabel.text = "완료"
                buttonLabel.textColor = .designSystem(.white)
            }
        case .completedAlert :
            alertInfo.text = "\(message.spaceName)의 정산이 완료되었습니다"
            iconImage.image = UIImage(named: "startAlertImage")
            iconImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            iconImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        }
    }
}
