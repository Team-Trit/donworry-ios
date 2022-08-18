//
//  AgreeTermViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/17.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Alamofire

final class AgreeTermViewController: BaseViewController {
    private lazy var descriptionLabel: UILabel = {
            let v = UILabel()
            v.text = "돈워리 이용을 위해\n약관에 동의해 주세요."
            v.font = .designSystem(weight: .bold, size: ._18)
            v.numberOfLines = 0
            return v
        }()
    private lazy var agreeTermTableView: AgreeTermTableView = {
        let v = AgreeTermTableView()
        v.backgroundColor = .white
        return v
    }()
    private lazy var doneButton: LargeButton = {
        let v = LargeButton(type: .done)
        v.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        v.isEnabled = true
        return v
    }()
    let viewModel = AgreeTermViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Layout
extension AgreeTermViewController {
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubviews(descriptionLabel, agreeTermTableView, doneButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        agreeTermTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-170)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(297)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Interaction Functions
extension AgreeTermViewController {
    @objc private func doneButtonPressed(_ sender: UIButton) {
//        present(ConfirmTermViewController(checkedTerms: getCheckedTerms()), animated: true)
        present(ConfirmTermViewController(), animated: true)
    }
}
