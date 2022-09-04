//
//  CategoryModels.swift
//  DonWorry
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum CategoryModels {
    enum FetchAll {
        typealias Response = [Category]
        
        struct Category {
            var id: Int
            var name: String
            var imgURL: String
        }
    }
}
