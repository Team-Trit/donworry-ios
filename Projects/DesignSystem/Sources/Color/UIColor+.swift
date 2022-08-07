//
//  UIColor+.swift
//  DesignSystem
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIColor {
    class func donworry(_ color: Pallete) -> UIColor? {
        guard let bundle = Bundle(identifier: "com.Tr-iT.DesignSystem") else { return nil}
        return UIColor(named: color.rawValue, in: bundle, compatibleWith: nil)
    }
}
