//
//  Formatter.swift
//  DonWorry
//
//  Created by Woody on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct Formatter {
    static let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    static let mmddDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()

    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    static let alarmDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "MM월 dd일 EEEE"
        return formatter
    }()

    static func addTimeZone(dateString: String) -> String {
        return dateString + ".100Z"
    }
}
