//
//  TestViewController.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

#if DEBUG
import UIKit
import DonWorryExtensions
import SnapKit
import RxSwift
import RxCocoa

class TestViewController: UIViewController {

    lazy var nicknameTextField: UITextField = {
        let v = UITextField()
        return v
    }()
    lazy var button: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("회원가입하기", for: .normal)
        v.setBackgroundColor(.green, for: .normal)
        v.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        return v
    }()
    var authService: AuthService = AuthServiceImpl()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(nicknameTextField)
        self.view.addSubview(button)
        nicknameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).inset(30)
        }
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc func buttonDidTap() {
        guard let nickName = self.nicknameTextField.text else { return }
        authService.postTestUser(
            provider: "KAKAO",
            nickname: nickName,
            email: "testuser@email.com",
            bank: "토스뱅크",
            bankNumber: "1000-283821-28",
            bankHolder: "우디",
            isAgreeMarketing: true
        ).subscribe(onNext: { [weak self] user in
            print("성공", user)
        }).disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
#endif
