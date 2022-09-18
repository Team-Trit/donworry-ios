//
//  UIDevice+Utils.swift
//  DonWorryExtensions
//
//  Created by Chanhee Jeong on 2022/09/19.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}
