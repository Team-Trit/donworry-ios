//
//  CategoryRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import RxSwift

final class CategoryRepositoryImpl: CategoryRepository {
    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func getAllCategories() -> Observable<CategoryModels.FetchAll.Response> {
        network.request(GetCategoriesAPI())
            .compactMap { response -> CategoryModels.FetchAll.Response in
                response.compactMap { dto -> CategoryModels.FetchAll.Category in
                        .init(id: dto.id, name: dto.name, imgURL: dto.imgUrl)
                }
            }.asObservable()
    }
}
