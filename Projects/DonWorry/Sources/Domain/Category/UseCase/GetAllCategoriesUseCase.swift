//
//  GetAllCategoriesUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryRepository {
    func getAllCategories() -> Observable<CategoryModels.FetchAll.Response>
}

protocol GetAllCategoriesUseCase {
    func getAllCategories() -> Observable<CategoryModels.FetchAll.Response>
    func findCategoryImageName(by id: Int) -> Observable<String>
}

final class GetAllCategoriesUseCaseImpl: GetAllCategoriesUseCase {
    private let categoryRepository: CategoryRepository
    var categories: CategoryModels.FetchAll.Response
    init(categoryRepository: CategoryRepository = CategoryRepositoryImpl()) {
        self.categoryRepository = categoryRepository
        self.categories = .init()
    }

    func getAllCategories() -> Observable<CategoryModels.FetchAll.Response> {
        categoryRepository.getAllCategories()
            .do(onNext: { [weak self] in
                self?.categories = $0
            })
    }

    func findCategoryImageName(by id: Int) -> Observable<String> {
        if let firstIndex = categories.firstIndex(where: { id == $0.id} ) {
            return .just(categories[firstIndex].name)
        }
        return .error(CategoryError.undefined)
    }

    enum CategoryError: Error {
        case undefined
    }
}
