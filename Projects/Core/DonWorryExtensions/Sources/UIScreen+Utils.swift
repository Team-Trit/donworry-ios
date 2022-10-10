//
//  UIScreen+.swift
//  DonWorryExtensions
//
//  Created by Chanhee Jeong on 2022/10/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIScreen {
  /// - Mini, SE: 375.0
  /// - pro: 390.0
  /// - pro max: 428.0
  var isWiderThan375pt: Bool { self.bounds.size.width > 375 }
}
