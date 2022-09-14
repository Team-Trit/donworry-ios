//
//  AlertTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import Models

struct AlarmCellViewModel {
    let title: String
    let message: String
    let type: AlarmType
    let spaceID: Int
    let paymentID: Int

    enum AlarmType {
        case payment_start
        case payment_end
        case payment_push
        case system

        var image: UIImage? {
            switch self {
            case .payment_start:
                return UIImage(.ic_calculation_3d)
            case .payment_end:
                return UIImage(.ic_calculation_3d)
            case .payment_push:
                return UIImage(.ic_money)
            default:
                return UIImage(.ic_money)
            }
        }
    }
}

protocol AlarmCellDelegate: AnyObject {
    func didTapSendMoneyButton(model: AlarmCellViewModel)
}

final class AlarmTableViewCell: UITableViewCell {
    static let identifier: String = "AlarmTableViewCell"
    weak var alarmCellDelegate: AlarmCellDelegate?
    var cellViewModel: AlarmCellViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = self?.cellViewModel?.title
                self?.alertInfo.text = self?.cellViewModel?.message
                self?.iconImage.image =  self?.cellViewModel?.type.image
                // TODO: 서버 API 수정에 대응할것 
                self?.sendDetailButton.isHidden = true // !(self?.cellViewModel?.type == .payment_push)
            }
        }
    }

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

    let titleLabel: UILabel = {
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

    private let sendDetailButton: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("정산하기", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .bold, size: ._13)
        v.setTitleColor(UIColor.designSystem(.white), for: .normal)
        return v
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
        iconImage.widthAnchor.constraint(equalToConstant: 26).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 26).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: smallRectangele.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: smallRectangele.trailingAnchor, constant: 10).isActive = true

        contentView.addSubview(alertInfo)
        alertInfo.bottomAnchor.constraint(equalTo: smallRectangele.bottomAnchor).isActive = true
        alertInfo.leadingAnchor.constraint(equalTo: smallRectangele.trailingAnchor, constant: 10).isActive = true

        contentView.addSubview(sendDetailButton)
        sendDetailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(40)
            make.width.equalTo(72)
            make.height.equalTo(33)
        }
        sendDetailButton.roundCorners(16.5)
    }

    @objc
    private func didTapSendDetailButton() {
        guard let cellViewModel = cellViewModel else {
            return
        }
        alarmCellDelegate?.didTapSendMoneyButton(model: cellViewModel)
    }
}