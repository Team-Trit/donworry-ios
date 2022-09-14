//
//  SplashViewController.swift
//  App
//
//  Created by Woody on 2022/09/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem

final class SplashViewController: BaseViewController, View {

    lazy var logoImageView: UIImageView = {
        let v = UIImageView(image: UIImage(.ic_spash_logo))
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        animateSplash()
    }

    private func setUI() {
        self.view.backgroundColor = .designSystem(.white)

        self.view.addSubview(self.logoImageView)

        self.logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    func bind(reactor: SplashViewReactor) {

    }

    private func animateSplash() {
        Timer.scheduledTimer(timeInterval: 2.3, target: self, selector: #selector(splashTimeOut), userInfo: nil, repeats: false)
    }

    @objc func splashTimeOut() {

    }
}
