//
//  DWNavigationBar.swift
//  DesignSystem
//
//  Created by 김승창 on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final public class DWNavigationBar: UIView {
    public lazy var leftItem: UIButton = {
        let v = UIButton(type: .system)
        let image = UIImage(
            systemName: "chevron.backward",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy)
        )
        v.setImage(image, for: .normal)
        return v
    }()
    public var titleLabel: UILabel?
    public var rightItem: UIButton?

    public enum RightButtonType {
        case text
        case image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackButton()
        setUI()
    }

    public convenience init(title: String, type: RightButtonType, rightButtonTitle: String = "", rightButtonImageName: String = "") {
        switch type {
        case .text:
            self.init(title: title, rightButtonTitle: rightButtonTitle)
        case .image:
            self.init(title: title, rightButtonImageName: rightButtonImageName)
        }
    }

    public convenience init(title: String, rightButtonTitle: String) {
        self.init(title: title)

        rightItem = UIButton(type: .system)
        rightItem?.setTitle(rightButtonTitle, for: .normal)
        rightItem?.setTitleColor(.designSystem(.redFF0B0B), for: .normal)
        rightItem?.titleLabel?.font = .designSystem(weight: .regular, size: ._18)
        setRightButton()
    }

    public convenience init(title: String, rightButtonImageName: String) {
        self.init(title: title)
        rightItem = UIButton(type: .system)
        let image = UIImage(
            systemName: rightButtonImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy)
        )
        rightItem?.setImage(image, for: .normal)
        rightItem?.tintColor = .designSystem(.black)
        setRightButton()
    }

    public convenience init(title: String) {
        self.init()

        titleLabel = UILabel()
        titleLabel?.font = .designSystem(weight: .heavy, size: ._20)
        titleLabel?.text = title
        setTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension DWNavigationBar {
    private func setUI() {
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    private func setBackButton() {
        leftItem.tintColor = .designSystem(.black)
        self.addSubview(leftItem)
        
        leftItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(50)
        }
    }
    
    private func setTitleLabel() {
        self.addSubview(titleLabel!)
        
        titleLabel?.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftItem.snp.centerY)
        }
    }
    
    private func setRightButton() {
        self.addSubview(rightItem!)
        
        rightItem?.snp.makeConstraints({ make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalTo(leftItem.snp.centerY)
        })
    }
}
