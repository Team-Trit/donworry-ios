//
//  SheetViewController.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

public struct SendingMoneyInfoViewModel {
    let name: String
    let date: String
    let totalAmount: Int
    let totalUers: Int
    let myAmount: Int
}

public struct SendingMoneyProgressInfoViewModel {
    let name: String
    let myAmount: Int
    let totalAmount: Int
    
}

let myMoneyInfo: [SendingMoneyInfoViewModel] = [
    SendingMoneyInfoViewModel(name: "우디네당구장", date: "05/25", totalAmount: 184000, totalUers: 4, myAmount: 44000),
    SendingMoneyInfoViewModel(name: "우디네당구장", date: "05/25", totalAmount: 152000, totalUers: 2, myAmount: 76000),
    SendingMoneyInfoViewModel(name: "안녕하세요", date: "03/45", totalAmount: 123000, totalUers: 5, myAmount: 12000),
    SendingMoneyInfoViewModel(name: "졸려죽겟다", date: "03/12", totalAmount: 39000, totalUers: 3, myAmount: 13000)
]

let myMoneyDetailInfo: [SendingMoneyProgressInfoViewModel] = [
    SendingMoneyProgressInfoViewModel(name: "유쓰", myAmount: 20000, totalAmount: 120000),
    SendingMoneyProgressInfoViewModel(name: "애셔", myAmount: 100000, totalAmount: 120000),
    SendingMoneyProgressInfoViewModel(name: "찰리", myAmount: 1000, totalAmount: 10000),
    SendingMoneyProgressInfoViewModel(name: "gg", myAmount: 2140, totalAmount: 2345)
]

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
