//
//  Pallete.swift
//  DesignSystemTests
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum Pallete: String {
    case mainBlue
    case lightBlue
    case gray1
    case gray2
    case white
    case topGradient
    case bottomGradient
    case brown
    case green

    var hexString: String {
        switch self {
        case .mainBlue:
            return "#1C6BFFFF"
        case .lightBlue:
            return "#A4C6FFFF"
        case .gray1:
            return "#818181FF"
        case .gray2:
            return "#C5C5C5FF"
        case .white:
            return "#F6F6F6"
        case .topGradient:
            return "#1B86F4FF"
        case .bottomGradient:
            return "#19B2F2FF"
        case .brown:
            return "#51312CFF"
        case .green:
            return "#6BAE66FF"
        }
    }
}
