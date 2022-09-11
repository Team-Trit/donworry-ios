//
//  ImageRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import DonWorryNetworking

protocol ImageRepository {
    func uploadImage(request: ImageModels.UploadImage.Request) -> Observable<ImageModels.UploadImage.Response>
}

final class ImageRepositoryImpl: ImageRepository {

    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func uploadImage(request: ImageModels.UploadImage.Request) -> Observable<ImageModels.UploadImage.Response> {
        guard let imageData = request.image.jpegData(compressionQuality: 1) else { return .error(ImageError.upload)}
        return network.request(UploadImageAPI(request: .init(imageData: imageData)))
            .compactMap { response in
                    .init(imageURL: response.imgUrl)
            }.asObservable()
    }
}
