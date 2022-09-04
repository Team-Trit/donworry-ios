//
//  UIColor+.swift
//  DesignSystem
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIColor {
    class func designSystem(_ color: Pallete) -> UIColor? {
        return UIColor(named: color.rawValue, in: Bundle.module, compatibleWith: nil)
    }
}
