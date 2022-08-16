//
//  ModalButtonViewController.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class ModalButtonViewController: UIViewController {
    
    let button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("모달띄우기", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(ModalButtonViewController.self, action: #selector(touchUpPresentModalButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    func render() {
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func touchUpPresentModalButton(_ sender: UIButton) {
        let vc = SentMoneyDetailViewViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
