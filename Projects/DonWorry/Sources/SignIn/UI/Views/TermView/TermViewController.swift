//
//  TermViewController.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import RxCocoa
import RxSwift
import UIKit

final class TermViewController: BaseViewController {
    private let descriptionLabel = UILabel()
    private let termTableView = TermTableView()
    private let nextButton = LargeButton(text: "다음", isDisabled: true)
    let viewModel = UserInfoViewModel()
    
    public override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = .white
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension TermViewController {
    private func attributes() {
        setDescriptionLabel()
        addTableViewController()
    }
    
    private func layout() {
        setDescriptionViewLayout()
        setNextButtonLayout()
    }
    
    // MARK: - Attributes Helper
    private func setDescriptionLabel() {
        descriptionLabel.text = "돈워리 이용을 위해\n약관에 동의해 주세요."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func addTableViewController() {
        addChild(termTableView)
        view.addSubview(termTableView.view)
        termTableView.didMove(toParent: self)
    }
    
    // MARK: - Layout Helper
    private func setDescriptionViewLayout() {
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    private func setNextButtonLayout() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }
}
