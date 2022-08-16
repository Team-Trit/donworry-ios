//
//  UIStackView+Utils.swift
//  DonWorryExtensions
//
//  Created by Chanhee Jeong on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIStackView {
  func addArrangedSubviews(_ subviews: UIView...) {
    for subview in subviews {
      addArrangedSubview(subview)
    }
  }
}
