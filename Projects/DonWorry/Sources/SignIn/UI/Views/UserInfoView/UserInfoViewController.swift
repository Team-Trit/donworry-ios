//
//  UserInfoViewController.swift
//  DonWorryTests
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import RxCocoa
import RxSwift
import UIKit

final class UserInfoViewController: BaseViewController {
    let viewModel = UserInfoViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension UserInfoViewController {
    private func attributes() {
        
    }
    
    private func layout() {
        
    }
}
