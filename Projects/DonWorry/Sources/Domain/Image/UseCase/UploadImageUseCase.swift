//
//  UploadImageUseCase.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol UploadImageUseCase {
    func uploadCard(request: ImageModels.UploadImage.Request) -> Observable<ImageModels.UploadImage.Response>
    func uploadProfileImage(request: ImageModels.UploadImage.Request) -> Observable<ImageModels.UploadImage.Response>
}

final class UploadImageUseCaseImpl: UploadImageUseCase {
    private let imageRepository: ImageRepository

    init( imageRepository: ImageRepository = ImageRepositoryImpl()) {
        self.imageRepository = imageRepository
    }
    
    func uploadCard(request: ImageModels.UploadImage.Request) -> Observable<ImageModels.UploadImage.Response> {
        imageRepository.uploadImage(request: request)
    }
    
    func uploadProfileImage(request: ImageModels.UploadImage.Request) -> Observable<ImageModels.UploadImage.Response> {
        imageRepository.uploadImage(request: request)
    }
}
