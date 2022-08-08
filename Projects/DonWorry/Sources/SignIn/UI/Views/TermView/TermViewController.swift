//
//  TermViewController.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import RxCocoa
import RxSwift
import UIKit

final class TermViewController: BaseViewController {
    private let descriptionLabel = UILabel()
    private let termStackView = UIStackView()
    private let nextButton = LargeButton(text: "다음", isDisabled: false)
    
    let viewModel = UserInfoViewModel()
    
    public override func viewDidLoad () {
        super.viewDidLoad()
        
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension TermViewController {
    private func attributes() {
        setDescriptionLabel()
    }
    
    private func layout() {
        
    }
    
    // MARK: - Attributes Helper
    private func setDescriptionLabel() {
        descriptionLabel.text = "돈워리 이용을 위해\n약관에 동의해 주세요."
        descriptionLabel.font = .systemFont(ofSize: 18)
    }
    
    
    // MARK: - Layout Helper
}
