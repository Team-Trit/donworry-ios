//
//  CardIcon.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum PaymentCardIcon: String {
    case chicken
    case coffee
    case wine
    case shopping
    case camera
    case dinner
    case birthday
    case gasStation
    case icecream
}

public struct CategoryIcon {
    public var id: Int
    public var content: String
    public var imageURL: String

    public init(
        id: Int,
        content: String,
        imageURL: String
    ) {
        self.id = id
        self.content = content
        self.imageURL = imageURL
    }
}
