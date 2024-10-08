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
    case gray818181
    case grayC5C5C5
    case white
    case blueTopGradient
    case blueBottomGradient
    case brown
    case green
    case black
    case white2
    case grayF6F6F6
    case redTopGradient
    case redBottomGradient
    case gray757474
    case gray696969
    case redFF0B0B
    case grayEEEEEE
    case grayF9F9F9
    case grayF5F4F4
    case gray4B4A4A
    case blueToast
    case redToast

    var hexString: String {
        switch self {
        case .mainBlue:
            return "#E4EBFAFF"
        case .lightBlue:
            return "#A4C6FFFF"
        case .gray818181:
            return "#818181FF"
        case .grayC5C5C5:
            return "#C5C5C5FF"
        case .white:
            return "#FFFFFFFF"
        case .blueTopGradient:
            return "#1B86F4FF"
        case .blueBottomGradient:
            return "#19B2F2FF"
        case .brown:
            return "#51312CFF"
        case .green:
            return "#6BAE66FF"
        case .black:
            return "#000000FF"
        case .white2:
            return "#F6F6F6FF"
        case .grayF6F6F6:
            return "#F6F6F6FF"
        case .redTopGradient:
            return "#FF5F5FFF"
        case .redBottomGradient:
            return "#FFA1B9FF"
        case .gray757474:
            return "757474FF"
        case .gray696969:
            return "696969FF"
        case .redFF0B0B:
            return "#FF0B0BFF"
        case .grayEEEEEE:
            return "#EEEEEEFF"
        case .grayF9F9F9:
            return "#F9F9F9FF"
        case .grayF5F4F4:
            return "#F5F4F4FF"
        case .gray4B4A4A:
            return "#4B4A4AFF"
        case .blueToast:
            return "#1C6BFFFF"
        case .redToast:
            return "#FF5F5FFF"
        }
    
    }
}
