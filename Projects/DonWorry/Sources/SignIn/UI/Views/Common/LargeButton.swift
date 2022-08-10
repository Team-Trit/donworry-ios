//
//  LargeButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

protocol LargeButtonDelegate: AnyObject {
    func buttonPressed()
}

final class LargeButton: UIView {
    lazy var button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//    var text = ""
//    var isEnabled = false
    var text: String
    var isEnabled: Bool
    weak var delegate: LargeButtonDelegate?

    init(text: String, isEnabled: Bool) {
        self.text = text
        self.isEnabled = isEnabled
//        super.init(frame: .zero)
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
    
    private func commonInit() {
        attributes()
        layout()
    }
}

// MARK: - Configurations
extension LargeButton {
    private func attributes() {
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        button.backgroundColor = isEnabled ? .designSystem(.mainBlue) : .designSystem(.gray2)
        button.layer.cornerRadius = 25
//        button.isEnabled = isEnabled
//        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed)))
       
    }
    
    private func layout() {
        addSubview(button)
        
        
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        
        
        print("able : \(button.isEnabled)")
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Interaction Functions
extension LargeButton {
//    @objc private func buttonPressed(sender: UITapGestureRecognizer) {
//        delegate?.buttonPressed()
//    }
    @objc private func buttonPressed(_ sender: UIButton) {
        print("first pressed")
        delegate?.buttonPressed()
    }
}
