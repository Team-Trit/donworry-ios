//
//  FakeDummyDataForAlertView.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum AlertType {
    case startAlert
    case hurriedAlert
    case completedAlert
}

struct AlertMessageInfomations {
    let recievedDate: String
    let senderName: String
    let spaceName: String
    let messageType: AlertType
}


