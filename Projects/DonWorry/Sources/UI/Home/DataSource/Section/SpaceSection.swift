//
//  SpaceSection.swift
//  DonWorry
//
//  Created by Woody on 2022/09/26.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum SpaceSection: Hashable {
    typealias Item = SpaceItem
    case spacelist([Item])
}

enum SpaceItem: Hashable {
    case space(SpaceCellViewModel)
}
