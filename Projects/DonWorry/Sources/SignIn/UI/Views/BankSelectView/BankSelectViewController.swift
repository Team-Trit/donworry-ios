//
//  BankSelectView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture

private let banks = ["경남은행", "광주은행", "국민은행", "기업은행", "농협은행", "대구은행", "부산은행", "산림조합중앙회", "산업은행", "새마을금고", "수협은행", "신한은행", "신협증앙회", "우리은행", "우체국", "저축은행", "전북은행", "제주은행", "카카오뱅크", "케이뱅크", "토스뱅크", "하나은행", "한국씨티은행", "한국투자증권", "KB증권", "NH투자증권", "SC제일은행"
]

final class BankSelectViewController: BaseViewController {
    private let titleLabel = UILabel()
    private let dismissButton = UIButton()
    private let searchTextField = UITextField()
    private let bankCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let viewModel = BankSelectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        attributes()
        layout()
        bankCollectionView.dataSource = self
        bankCollectionView.delegate = self
    }
}

// MARK: - Configuration
extension BankSelectViewController {
    private func attributes() {
        titleLabel.text = "은행선택"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        dismissButton.setTitle("취소", for: .normal)
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 15)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        
        // SearchTextField
        searchTextField.placeholder = "은행검색"
        searchTextField.backgroundColor = .systemGray6
        searchTextField.layer.cornerRadius = 7
        let leftImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        guard let size = leftImage?.size.width else { return }
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: size + 20, height: size))
        let leftImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: size, height: size))
        leftImageView.image = leftImage
        leftImageView.tintColor = .systemGray
        frameView.addSubview(leftImageView)
        searchTextField.leftView = frameView
        searchTextField.leftViewMode = .always
        
        // CollectionView Register
        bankCollectionView.register(BankCell.self, forCellWithReuseIdentifier: BankCell.identifier)
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(bankCollectionView)
        bankCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bankCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            bankCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            bankCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            bankCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - DataSource
extension BankSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bankCollectionView.dequeueReusableCell(withReuseIdentifier: BankCell.identifier, for: indexPath) as! BankCell
        let bank = banks[indexPath.row]
        cell.bankIconView.image = UIImage(named: bank)
        cell.bankLabel.text = bank
        return cell
    }
}

// MARK: - Delegate
extension BankSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 30
        let height: CGFloat = 45
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - Interaction Functions
extension BankSelectViewController {
    @objc private func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
