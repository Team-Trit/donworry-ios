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


final class RoomNameEditViewController: BaseViewController, View {
    
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
    private lazy var titleLabel: UILabel = {
        $0.text = setTitleLabelText(type: type)
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())
    
    private lazy var paymentNameLabel = LimitTextField(placeholder: setPlaceholderText(type: type), limit: 20)
    
    private lazy var nextButton = LargeButton(type: .next)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }

    // MARK: - Binding
    func bind(reactor: PaymentCardNameEditViewReactor) {
        //binding here
    }

}

// MARK: - setUI

extension RoomNameEditViewController {

    private func setUI() {
        navigationItem.title = "네비게이션바 넣어요" //TODO: 네비게이션바 교체필요
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(titleLabel, paymentNameLabel,nextButton)
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        paymentNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
    }

}

// MARK: - Method
extension RoomNameEditViewController {
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
                return "MC2 번개모임"
        }
    }
}
