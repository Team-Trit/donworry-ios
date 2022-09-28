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
            let data: MoreData?

            struct MoreData {
                let senderImgURL: String?
                let spaceID: String?
                let paymentID: String?
            }
            enum AlarmType {
                case system
                case payment_start
                case payment_end
                case paymnet_push
                case space
            }
        }
    }

    enum PushPayments {
        struct Request {
            let spaceID: Int
            let payments: [Payment]
            init(spaceID: Int, payments: [Payment]) {
                self.spaceID = spaceID
                self.payments = payments
            }

            struct Payment: Encodable {
                let id: Int
                let receiverID: Int
                let isCompleted: Bool
                init(id: Int, receiverID: Int, isCompleted: Bool) {
                    self.id = id
                    self.receiverID = receiverID
                    self.isCompleted = isCompleted
                }
            }
        }
    }

    enum Empty {
        struct Response {}
    }
}
