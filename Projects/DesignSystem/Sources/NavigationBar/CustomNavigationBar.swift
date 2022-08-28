//
//  CustomNavigationBar.swift
//  DesignSystem
//
//  Created by 김승창 on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final public class CustomNavigationBar: UIView {
    private lazy var leftItem: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(.back_button), for: .normal)
        return v
    }()
    private var titleLabel: UILabel?
    private var rightItem: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackButton()
    }
    
    public convenience init(title: String) {
        self.init()
        
        titleLabel = UILabel()
        titleLabel?.font = .designSystem(weight: .heavy, size: ._20)
        titleLabel?.text = title
        setTitleLabel()
    }
    
    public convenience init(title: String, rightButtonTitle: String) {
        self.init(title: title)
        
        rightItem = UIButton()
        rightItem?.setTitle(rightButtonTitle, for: .normal)
        rightItem?.setTitleColor(.designSystem(.redFF0B0B), for: .normal)
        rightItem?.titleLabel?.font = .designSystem(weight: .regular, size: ._18)
        setRightButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension CustomNavigationBar {
    private func setBackButton() {
        self.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        self.addSubview(leftItem)
        
        leftItem.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(25)
            make.width.equalTo(15)
            make.height.equalTo(25)
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
