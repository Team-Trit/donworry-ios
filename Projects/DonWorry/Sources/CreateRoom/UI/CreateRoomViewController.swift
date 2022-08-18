//
//  CreateRoomViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import DesignSystem
import RxCocoa
import RxSwift


final class CreateRoomViewController: BaseViewController {
    
    let viewModel = CreateRoomViewModel()

    private lazy var nextButton = LargeButton(type: .next)
    private lazy var textField = RoomNameTextField(type: 0)
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        didChangeIndex(type: 2)
    }
    
    
    private func didChangeIndex(type: Int) {
        switch (type) {
        case 0:
            infoLabel.text = "정산방을\n생성해볼까요?"
            textField = RoomNameTextField(type: 0)
        case 1:
            infoLabel.text = "정산방\n이름을 설정해주세요"
            textField = RoomNameTextField(type: 1)
        case 2:
            infoLabel.text = "닉네임을\n수정해볼까요?"
            textField = RoomNameTextField(type: 2)
        default:
            break
        }
    }
//    @objc func showMiracle() {
//        let slideVC = EnterRoomViewController()
//        slideVC.modalPresentationStyle = .custom
//        slideVC.transitioningDelegate = self
//        self.present(slideVC, animated: true, completion: nil)
//    }
    
}


extension CreateRoomViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension CreateRoomViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.addSubviews(textField, nextButton)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(63)
            make.leading.trailing.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
