//
//  ImageModels.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

enum ImageModels {

    // MARK: 하나의 이미지 업로드하기

    enum UploadImage {

        struct Request {
            let image: UIImage
            let type: String
        }

        struct Response {
            let imageURL: String
        }
    }

}
