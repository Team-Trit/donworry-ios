//
//  TermConfirmView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import UIKit

final class TermConfirmView: BaseViewController {
    private let confirmButton = LargeButton(text: "확인", isDisabled: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension TermConfirmView {
    private func attributes() {
        
    }
    
    private func layout() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Attibutes Helper
    private func setTitleLabel() {
        
    }
}
