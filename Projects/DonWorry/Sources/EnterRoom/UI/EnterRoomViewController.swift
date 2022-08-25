//
//  EnterRoomViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/24.
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

final class EnterRoomViewController: BaseViewController, View {
    
    private lazy var textField = LimitTextField(frame: .zero, type: .roomCode)
    private lazy var nextButton = LargeButton(type: .enter)
    private lazy var titleLabel: UILabel = {
        $0.text = "정산방 코드로 정산에 참가하기"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    private lazy var ImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "cash_and_coins")
        return v
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }

    func bind(reactor: EnterRoomViewReactor) {
        //binding here
    }

}

// MARK: setUI

extension EnterRoomViewController {

    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(ImageView, titleLabel, textField, nextButton)
        
        ImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().inset(110)
            $0.trailing.equalToSuperview().inset(98)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(ImageView.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
