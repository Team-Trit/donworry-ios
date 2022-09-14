//
//  AlarmModels.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum AlarmModels {
    enum GetAlarms {
        typealias Response = [Alarm]
        struct Alarm {
            let id: Int
            let type: AlarmType
            let title: String
            let message: String
            let createdDate: String
            
            enum AlarmType {
                case system
                case payment_start
                case payment_end
                case paymnet_push
                case space
            }
        }
    }
    enum Empty {
        struct Response {}
    }
}
