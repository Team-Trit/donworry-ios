//
//  RoomNameEditViewController.swift
//  DonWorry
//
//  Created by 임영후 on 2022/08/21.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions
import SnapKit


final class EditRoomNameViewController: BaseViewController, View {

    // MARK: - Init
    enum RoomNameEditViewType {
        case create //default
        case rename
    }

    var type: RoomNameEditViewType = .create

    convenience init(type: RoomNameEditViewType) {
        self.init()
        self.type = type
    }

    // MARK: - Views
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        $0.text = setTitleLabelText(type: type)
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())

    private lazy var roomInfoLabel = LimitTextField(frame: .zero, type: .roomName)
    private lazy var nextButton = DWButton.create(.xlarge58)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
        bindBackButton()
    }

    // MARK: - Binding
    func bind(reactor: EditRoomNameViewReactor) {
        //binding here
    }


    // MARK: - 코드 테스트
    @objc func codeSheet() {
        let enterCodeVC = EnterRoomViewController()
        if #available(iOS 15.0, *) {
            if let sheet = enterCodeVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        } else {
            // Fallback on earlier versions
        }
        present(enterCodeVC, animated: true)
    }
}

// MARK: - setUI

extension EditRoomNameViewController {
    private func bindBackButton() {
        navigationBar.leftItem.rx.tap
            .bind { self.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
    }

    private func setUI() {
        nextButton.title = "정산방 참가하기"
        navigationItem.title = "네비게이션바 넣어요" //TODO: 네비게이션바 교체필요
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, roomInfoLabel, nextButton)

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

// MARK: - Method
extension EditRoomNameViewController {
    private func setTitleLabelText(type: RoomNameEditViewType) -> String {
        switch type {
            case .create:
                return "정산방을\n생성해볼까요?"
            case .rename:
                return "정산방\n이름을 설정해주세요"
        }
    }

    private func setPlaceholderText(type: RoomNameEditViewType)  -> String {
        switch type {
            case .create:
                return "정산방 이름을 입력하세요."
            case .rename:
                return "ex) MC2 번개모임"
        }
    }
}
