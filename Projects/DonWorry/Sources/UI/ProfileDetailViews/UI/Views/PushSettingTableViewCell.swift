//
//  PushSettingTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

protocol toggleAlertDelegate {
    func toggleAlertTrue()
    func toggleAlertFalse()
    func goToSettingPage()
}

class PushSettingTableViewCell: UITableViewCell {
    
    static let identifier: String = "PushSettingTableViewCell"
    
    var toggleDelegate: toggleAlertDelegate?
    
    let mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.textColor = .designSystem(.black)
        mainTitle.font = .designSystem(weight: .regular, size: ._15)
        return mainTitle
    }()
    
    let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.textColor = .designSystem(.gray818181)
        subTitle.font = .designSystem(weight: .regular, size: ._13)
        return subTitle
    }()
    
    let toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = .designSystem(.mainBlue)
        toggleSwitch.setOn(false, animated: true)
        toggleSwitch.addTarget(self, action: #selector(onClickSwitch), for: .valueChanged)
        return toggleSwitch
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .designSystem(.grayF6F6F6)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        contentView.addSubviews(mainTitle, subTitle, toggleSwitch, lineView)
        mainTitle.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        mainTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).isActive = true
        mainTitle.widthAnchor.constraint(equalToConstant: 130).isActive = true
        mainTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        subTitle.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 1).isActive = true
        subTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).isActive = true
        subTitle.widthAnchor.constraint(equalToConstant: 130).isActive = true
        subTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        toggleSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        toggleSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26).isActive = true
        
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    func configure(data: Toggle) {
        mainTitle.text = data.main
        subTitle.text = data.sub
    }
    
    @objc func onClickSwitch() {
        if !self.toggleSwitch.isOn {
            toggleDelegate?.toggleAlertTrue()
        } else {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings {settings in
                DispatchQueue.main.async {
                    settings.authorizationStatus == .authorized ? self.toggleDelegate?.toggleAlertFalse() : self.toggleDelegate?.goToSettingPage()
                }
            }
        }
    }
}
