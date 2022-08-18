//
//  EnterRoomViewController.swift
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


final class EnterRoomViewController: BaseViewController {
    
    let viewModel = EnterRoomViewModel()

    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    private lazy var nextButton = LargeButton(type: .enter)
    private lazy var roomCodeTextField = RoomNameTextField()
    
    @IBOutlet weak var enterRoomLabel: UILabel!
    @IBOutlet weak var slideIndicator: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        slideIndicator.layer.cornerRadius = 2
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        
        view.addGestureRecognizer(panGesture)
    }
    
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}

extension EnterRoomViewController {

    private func setUI() {
        view.backgroundColor = .white
        view.addSubviews(roomCodeTextField, nextButton)
        
        roomCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(enterRoomLabel.snp.bottom).offset(59)
            make.leading.trailing.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
