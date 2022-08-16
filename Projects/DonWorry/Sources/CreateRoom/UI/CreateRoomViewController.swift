//
//  CreateRoomViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift

final class CreateRoomViewController: BaseViewController {
    
    let viewModel = CreateRoomViewModel()

    
    @IBOutlet weak var nextStepButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        nextStepButton.layer.cornerRadius = 25
        attributes()
        layout()
    }
    
    @objc func showMiracle() {
        let slideVC = EnterRoomViewController()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction func onButton(_ sender: Any) {
        showMiracle()
    }
}

extension CreateRoomViewController {

    private func attributes() {
        
    }

    private func layout() {

    }
}

extension CreateRoomViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
