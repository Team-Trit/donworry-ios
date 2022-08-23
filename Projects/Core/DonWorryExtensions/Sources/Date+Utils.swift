//
//  Date+Utils.swift
//  DonWorryExtensions
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension Date {
    /**
     # formatted
     - Note: 입력한 Format으로 변형한 String 반환
     - Parameters:
        - format: 변형하고자 하는 String타입의 Format (ex : "yyyy/MM/dd")
     - Returns: DateFormatter로 변형한 String
    */
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        return formatter.string(from: self)
    }
}
