//
//  Alert.swift
//  Models
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum AlertType {
    case startAlert
    case hurriedAlert
    case completedAlert
}

public struct AlertMessageInfomations {
   public let recievedDate: String
   public let senderName: String
   public let spaceName: String
   public let messageType: AlertType
   public var isCompleted: Bool = false
    
    public init(recievedDate: String, senderName: String, spaceName: String, messageType: AlertType) {
        self.recievedDate = recievedDate
        self.senderName = senderName
        self.spaceName = spaceName
        self.messageType = messageType
    }
    
    public init(recievedDate: String, senderName: String, spaceName: String, messageType: AlertType, isCompleted: Bool) {
        self.recievedDate = recievedDate
        self.senderName = senderName
        self.spaceName = spaceName
        self.messageType = messageType
        self.isCompleted = isCompleted
    }
}

