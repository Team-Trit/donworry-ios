//
//  PaddedTextField.swift
//  DesignSystem
//
//  Created by 김승창 on 2022/09/15.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final public class PaddedTextField: UITextField {
    var textPadding = UIEdgeInsets(
        top: 2,
        left: 0,
        bottom: 2,
        right: 0
    )
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
