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

final class JoinSpaceViewController: BaseViewController, View {

    lazy var dismissButton = UIButton(type: .system)
    private lazy var shareIDView = LimitTextField(frame: .zero, type: .roomCode)
    private lazy var nextButton = DWButton.create(.xlarge50)
    private lazy var titleLabel: UILabel = {
        $0.text = "정산방 코드로 정산에 참가하기"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "cash_and_coins")
        v.contentMode = .scaleAspectFit
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }

    func bind(reactor: JoinSpaceReactor) {
        dismissButton.rx.tap.map { .didTapDismissButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap.map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        shareIDView.textField.rx.text.compactMap { $0 }
            .map { .typeTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sharedID }
            .map { !$0.isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.move(to: $0)
            }).disposed(by: disposeBag)

        reactor.pulse(\.$error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                DWToastFactory.show(message: message, type: .error)
            }).disposed(by: disposeBag)
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// 배경 터치시  포커싱 해제
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.shareIDView.textField.resignFirstResponder()
    }

    /// 키보드 Show 시에 위치 조정
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - 15)
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    /// 키보드 Hide 시에 위치 조정
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) {
            self.nextButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: setUI

extension JoinSpaceViewController {

    private func setUI() {
        self.dismissButton.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        self.dismissButton.setTitle("취소", for: .normal)
        self.dismissButton.setTitleColor(.designSystem(.redFF0B0B), for: .normal)
        self.nextButton.title = "다음"
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(dismissButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(shareIDView)
        view.addSubview(nextButton)

        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 95).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 181).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 118).isActive = true

        dismissButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(16)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.centerX.equalToSuperview()
            make.width.equalTo(182)
            make.height.equalTo(118)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        shareIDView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension JoinSpaceViewController {
    func move(to step: JoinSpaceStep) {
        switch step {
        case .dismiss:
            self.dismiss(animated: true)
        case .paymentCardList(let space):
            self.dismiss(animated: true) {
                NotificationCenter.default.post(
                    name: .init("com.TriT.DonWorry.joinSpace"),
                    object: nil,
                    userInfo: [
                        "joinSpace.spaceID": space.id,
                        "joinSpace.adminID": space.adminID,
                        "joinSpace.status": space.status
                    ]
                )
            }
        }
    }
}
