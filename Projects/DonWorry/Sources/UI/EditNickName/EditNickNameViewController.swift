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
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        $0.text = "닉네임을\n수정해볼까요?"
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())

    private lazy var roomInfoLabel = LimitTextField(frame: .zero, type: .nickName)
    private lazy var nextButton = DWButton.create(.xlarge50)


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
        bindBackButton()
    }

    func bind(reactor: EditNickNameViewReactor) {
        //binding here
    }

}

// MARK: setUI

extension EditNickNameViewController {
    func bindBackButton() {
        navigationBar.leftItem.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func setUI() {
        nextButton.title = "다음" // TODO: 수정해야해요

        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, roomInfoLabel,nextButton)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }

        roomInfoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.trailing.equalToSuperview().inset(25)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
    }
}
