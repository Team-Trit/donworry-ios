//
//  TermUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

protocol TermRepository {
    func fetchTerms() -> [Term]
}

protocol TermUseCase {
    func fetchTerms() -> [Term]
}

final class TermUseCaseImpl: TermUseCase {
    private let termRepository: TermRepository
    
    init(_ termRepository: TermRepository = TermRepositoryImpl()) {
        self.termRepository = termRepository
    }
    
    func fetchTerms() -> [Term] {
        return termRepository.fetchTerms()
    }
}
