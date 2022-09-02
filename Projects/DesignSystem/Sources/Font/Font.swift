//
//  Font.swift
//  DesignSystem
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public enum Font {

    public enum Name: String {
        case system
        case gmarketsans = "GmarketSans"
    }
    public enum Size: CGFloat {
        case _50 = 50
        case _30 = 30
        case _25 = 25
        case _20 = 20
        case _18 = 18
        case _17 = 17
        case _15 = 15
        case _13 = 13
        case _10 = 10
        case _9 = 9
    }

    public enum Weight: String {
        case heavy = "Heavy"
        case bold = "Bold"
        case regular = "Regular"
        case light = "Light"

        var real: UIFont.Weight {
            switch self {
            case .heavy:
                return .heavy
            case .bold:
                return .bold
            case .regular:
                return .regular
            case .light:
                return .light
            }
        }
    }

    public struct DWFont {
        private let _name: Name
        private let _weight: Weight

        init(name: Name, weight: Weight) {
            self._name = name
            self._weight = weight
        }

        var name: String {
            "\(_name.rawValue)TTF\(_weight.rawValue)"
        }

        var `extension`: String {
            return "ttf"
        }
    }

    /// 모든 폰트 파일 등록
    /// - 앱 초기에 최초 한 번 실행
    public static func registerFonts() {
        fonts.forEach {
            Font.registerFont(fontName: $0.name, fontExtension: $0.extension)
        }
    }
}

extension Font {
    public static var fonts: [DWFont] {
        [
            DWFont(name: .gmarketsans, weight: .bold),
            DWFont(name: .gmarketsans, weight: .light)
        ]
    }

    private static func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle(identifier: "com.TriT.DesignSystem")?.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
