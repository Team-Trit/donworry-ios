//
//  SentMoneyDetailViewViewController.swift
//  App
//
//  Created by uiskim on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class SentMoneyDetailViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = SentMoneyDetailViewViewModel()
    
    private var statusView: SentMoneyDetailStatusView = {
        let status = SentMoneyDetailStatusView()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.configure(recievedUser: "애셔", payment: 100000, totalAmount: 120000)
        return status
    }()
    
    private let questionButton: UIImageView = {
        let questionButton = UIImageView()
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        questionButton.image = UIImage(named: "QuestionMark")
        return questionButton
    }()
    
    private let accountInfo: AccountInformationView = {
        let accontInfo = AccountInformationView()
        accontInfo.translatesAutoresizingMaskIntoConstraints = false
        accontInfo.configure(bank: "우리은행", account: "1002 - 045 - 401235", name: "임영후")
        accontInfo.layer.masksToBounds = true
        accontInfo.layer.cornerRadius = 8
        accontInfo.backgroundColor = .lightGray
        return accontInfo
    }()
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray
        return separatorView
    }()
    
    private let questionView: QuestionInformationView = {
        let questionView = QuestionInformationView()
        questionView.isHidden = true
        questionView.frame = CGRect(x: 195, y: 120, width: 168, height: 76)
        questionView.layer.masksToBounds = true
        questionView.layer.cornerRadius = 8
        questionView.backgroundColor = .gray
        return questionView
    }()
    

    
    private let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.text = "나의 정산 총액"
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        subTitle.textColor = .black
        return subTitle
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SentMoneyTableViewCell.self, forCellReuseIdentifier: SentMoneyTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private let totalAmountLabel: UILabel = {
        let totalAmountLabel = UILabel()
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.text = "나의 정산 총액"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        totalAmountLabel.textColor = .black
        return totalAmountLabel
    }()

    private let totalAmount: UILabel = {
        let totalAmount = UILabel()
        totalAmount.translatesAutoresizingMaskIntoConstraints = false
        totalAmount.textColor = .blue
        totalAmount.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        totalAmount.attributedText = makeAtrributedString(money: 120000)
        return totalAmount
    }()
    
    private let leftButtomButton: UIButton = {
       let buttonButton = UIButton()
        buttonButton.frame = CGRect(x: 21, y: 746, width: 222, height: 58)
        buttonButton.backgroundColor = UIColor.blue
        buttonButton.layer.masksToBounds = true
        buttonButton.layer.cornerRadius = 29
        buttonButton.setTitle("계좌번호 복사하기", for: .normal)
        buttonButton.setTitleColor(.white, for: .normal)
        buttonButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return buttonButton
    }()
    
    private let rightButtomButton: UIButton = {
       let buttonButton = UIButton()
        buttonButton.frame = CGRect(x: 262, y: 746, width: 103, height: 58)
        buttonButton.backgroundColor = UIColor.blue
        buttonButton.layer.masksToBounds = true
        buttonButton.layer.cornerRadius = 29
        buttonButton.setTitle("보냈어요!", for: .normal)
        buttonButton.setTitleColor(.white, for: .normal)
        buttonButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return buttonButton
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        let appearTapGesture = UITapGestureRecognizer(target: self, action: #selector(appearInfoTap))
        let copyTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyTap))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        questionButton.addGestureRecognizer(appearTapGesture)
        questionButton.isUserInteractionEnabled = true
        accountInfo.addGestureRecognizer(copyTapGesture)
        attributes()
        layout()
    }
    
    @objc func appearInfoTap() {
        print("is tapped")
        questionView.isHidden.toggle()
    }
    
    @objc func copyTap() {
        print("복사되었습니다")
    }

}

extension SentMoneyDetailViewViewController {

    private func attributes() {

    }

    private func layout() {
        view.addSubview(statusView)
        statusView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(questionButton)
        questionButton.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 78).isActive = true
        questionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 160).isActive = true
        questionButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        questionButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        view.addSubview(questionView)
        
        view.addSubview(accountInfo)
        accountInfo.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 20).isActive = true
        accountInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountInfo.heightAnchor.constraint(equalToConstant: 90).isActive = true
        accountInfo.widthAnchor.constraint(equalToConstant: 340).isActive = true
        
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: accountInfo.bottomAnchor, constant: 40).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        view.addSubview(subTitle)
        subTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20).isActive = true
        subTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        subTitle.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(totalAmountLabel)
        totalAmountLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        totalAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        totalAmountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(totalAmount)
        totalAmount.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor).isActive = true
        totalAmount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        totalAmount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(leftButtomButton)
        view.addSubview(rightButtomButton)
    }
}

extension SentMoneyDetailViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SentMoneyTableViewCell.identifier, for: indexPath)
                as? SentMoneyTableViewCell else { return UITableViewCell() }
        cell.configure(icon: "flame.fill", myPayment: payments[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
}

extension SentMoneyDetailViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

func makeAtrributedString(money: Int) -> NSMutableAttributedString {
    let numberformatter = NumberFormatter()
    numberformatter.numberStyle = .decimal
    let paymentString = numberformatter.string(for: money)! + "원"
    let attributedQuote = NSMutableAttributedString(string: paymentString)
    attributedQuote.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .bold), range: (paymentString as NSString).range(of: "원"))
    
    return attributedQuote
}
