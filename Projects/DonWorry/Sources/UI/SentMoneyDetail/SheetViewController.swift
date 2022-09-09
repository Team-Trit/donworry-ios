//
//  SheetViewController.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class SheetViewController: UIViewController {
    
    let sheetShowButton: DWButton = {
        let sheetShowButton = DWButton.create(.xlarge50)
        sheetShowButton.translatesAutoresizingMaskIntoConstraints = false
        sheetShowButton.title = "하프시트"
        sheetShowButton.addTarget(self, action: #selector(sheetShow), for: .touchUpInside)
        return sheetShowButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(sheetShowButton)
        sheetShowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sheetShowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sheetShowButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func sheetShow() {
        if #available(iOS 15.0, *) {
            let sheet = SentMoneyDetailViewController()
            if let presentationController = sheet.sheetPresentationController {
                presentationController.detents = [.medium()]
                presentationController.prefersGrabberVisible = true
            }
            present(sheet, animated: true)
        }
    }
}
