//
//  UIWindow+Utils.swift
//  DonWorryExtensions
//
//  Created by Chanhee Jeong on 2022/09/19.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIWindow {

    public static var current: UIWindow? {
        UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
    

}

