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

var alertMessages: [AlertMessageInfomations] = [
    AlertMessageInfomations(recievedDate: "21일 토요일", senderName: "유쓰", spaceName: "3차 애셔택시", messageType: .hurriedAlert),
    AlertMessageInfomations(recievedDate: "21일 토요일", senderName: "유쓰", spaceName: "2차 유쓰택시", messageType: .hurriedAlert),
    AlertMessageInfomations(recievedDate: "22일 일요일", senderName: "유쓰", spaceName: "4차 맥주", messageType: .startAlert),
    AlertMessageInfomations(recievedDate: "22일 일요일", senderName: "유쓰", spaceName: "MC2", messageType: .completedAlert),
    AlertMessageInfomations(recievedDate: "22일 일요일", senderName: "유쓰", spaceName: "MC2", messageType: .hurriedAlert),
    AlertMessageInfomations(recievedDate: "24일 화요일", senderName: "애셔", spaceName: "1차 고깃집 파티~", messageType: .startAlert)
]

func chunkedMessages(messages: [AlertMessageInfomations]) -> [[AlertMessageInfomations]] {
    var messagesByDate: [[AlertMessageInfomations]] = []
    var currentDateMessages: [AlertMessageInfomations] = []
    
    for message in messages {
        if let lastElement = currentDateMessages.last {
            if lastElement.recievedDate != message.recievedDate {
                messagesByDate.append(currentDateMessages)
                currentDateMessages = []
            }
        }
        currentDateMessages.append(message)
    }
    messagesByDate.append(currentDateMessages)
    return messagesByDate
    
}

var sortedMessages: [[AlertMessageInfomations]] {
     chunkedMessages(messages: alertMessages.sorted(by: {$0.recievedDate > $1.recievedDate}))
}


