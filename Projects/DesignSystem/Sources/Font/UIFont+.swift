//
//  Font+.swift
//  DesignSystem
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

extension UIFont {
    public class func designSystem(weight: Font.Weight, size: Font.Size) -> UIFont {
        return .systemFont(ofSize: size.rawValue, weight: weight.real)
    }
    public class func gmarksans(weight: Font.Weight, size: Font.Size) -> UIFont {
        let font = Font.DWFont(name: .gmarketsans, weight: weight)
        return ._font(name: font.name, size: size.rawValue)
    }
    private static func _font(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}
