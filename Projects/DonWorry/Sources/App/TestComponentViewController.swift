//
//  TestViewController.swift
//  DonWorry
//
//  Created by Woody on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

class TestComponentViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.spacing = 10
        v.distribution = .equalCentering
        v.alignment = .center
        v.axis = .vertical
        return v
    }()

    lazy var button1: DWButton = {
        let v = DWButton.create(.halfLightBlue)
        v.isEnabled = false
        v.title = "Next"
        return v
    }()
    lazy var button2: DWButton = {
        let v = DWButton.create(.halfMainBlue)
        v.title = "Next"
        return v
    }()

    lazy var button3: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "Next"
        v.isEnabled = false
        return v
    }()

    lazy var button4: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "Next"
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackView)
        stackView.addArrangedSubview(self.button1)
        stackView.addArrangedSubview(self.button2)
        stackView.addArrangedSubview(self.button3)
        stackView.addArrangedSubview(self.button4)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
    }

}
