//
//  NicknameEditViewController.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift

final class NicknameEditViewController: BaseViewController, View {
    typealias Reactor = NicknameEditViewReactor
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "닉네임을\n수정해볼까요?"
        v.numberOfLines = 0
        v.setLineSpacing(spacing: 10.0)
        v.font = .designSystem(weight: .heavy, size: ._25)
        return v
    }()
    private lazy var nicknameEditField: LimitTextField = {
        let v = LimitTextField(frame: .zero, type: .nickName)
        v.textField.attributedPlaceholder = NSAttributedString(string: (reactor?.user.nickName)!, attributes: [.font: UIFont.designSystem(weight: .regular, size: ._15)])
        return v
    }()
    private lazy var doneButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.setTitle("완료", for: .normal)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }
    
    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension NicknameEditViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, nicknameEditField, doneButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        nicknameEditField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
extension NicknameEditViewController {
    private func dispatch(to reactor: Reactor) {
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.pressBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nicknameEditField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateNickname(nickname: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.pressDoneButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
        
    private func render(_ reactor: Reactor) {
        reactor.pulse(\.$isDoneButtonAvailable)
            .asDriver(onErrorJustReturn: false)
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: NicknameEditViewStep.none)
            .compactMap { $0 }
            .drive { [weak self] in
                self?.route(to: $0)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension NicknameEditViewController {
    private func route(to: NicknameEditViewStep) {
        switch to {
        case .none:
            break
            
        case .pop:
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Keyboard Helper
extension NicknameEditViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.nicknameEditField.textField.resignFirstResponder()
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.doneButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - 15)
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) {
            self.doneButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
    }
}
