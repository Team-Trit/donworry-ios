//
//  EnterRoomViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class EnterRoomViewController: BaseViewController {
    
    let viewModel = EnterRoomViewModel()

    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    
    @IBOutlet weak var slideIndicator: UIView!
    @IBOutlet weak var enterRoomButton: UIButton!
    @IBAction func enterRoomButton(_ sender: Any) {

    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

//        slideIndicator.layer.cornerRadius = 2
//        enterRoomButton.layer.cornerRadius = 25
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
//        slideIndicator.roundCorners(.allCorners, radius: 5)
//        enterRoomButton.roundCorners(.allCorners, radius: 5)
        
        attributes()
        layout()
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

    private func attributes() {

    }

    private func layout() {

    }
}
