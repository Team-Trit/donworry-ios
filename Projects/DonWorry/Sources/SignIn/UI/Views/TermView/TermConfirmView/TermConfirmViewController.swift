//
//  TermConfirmView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import UIKit

final class TermConfirmViewController: BaseViewController {
    private let confirmButton = LargeButton(type: .done)
    let viewModel = TermConfirmViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension TermConfirmViewController {
    private func attributes() {
        
    }
    
    private func layout() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}
