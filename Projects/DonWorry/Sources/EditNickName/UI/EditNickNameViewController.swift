//
//  EditNickNameViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/25.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions
import SnapKit

final class EditNickNameViewController: BaseViewController, View {
    
    private lazy var titleLabel: UILabel = {
        $0.text = "닉네임을\n수정해볼까요?"
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())
    
    private lazy var roomInfoLabel = LimitTextField(frame: .zero, type: .nickName)
    private lazy var nextButton = LargeButton(type: .done)
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }

    func bind(reactor: EditNickNameViewReactor) {
        //binding here
    }

}

// MARK: setUI

extension EditNickNameViewController {

    private func setUI() {
        navigationItem.title = "네비게이션바 넣어요" //TODO: 네비게이션바 교체필요
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(titleLabel, roomInfoLabel,nextButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        roomInfoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
