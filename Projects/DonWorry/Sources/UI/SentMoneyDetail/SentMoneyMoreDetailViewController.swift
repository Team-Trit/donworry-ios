//
//  FullSheetSentDetailViewController.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

struct SentMoneyMoreDetailViewModel {
    var totalAmount: Int
    var sentMoneyList: [SentMoneyCellViewModel]
    var myMoneyDetailInfoList: [DetailProgressCellViewModel]
    
    var total: Int {
        var total = 0
        sentMoneyList.forEach { element in
            total += element.myAmount
        }
        return total
    }
}
class SentMoneyMoreDetailViewController: UIViewController, UITableViewDelegate {
    
    private let mainTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "총 정산 내역"
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.textColor = .black
        return title
    }()
    
    private let detailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.register(SentMoneyTableViewCell.self, forCellReuseIdentifier: SentMoneyTableViewCell.identifier)
        tableView.register(DetailProgressTableViewCell.self, forCellReuseIdentifier: DetailProgressTableViewCell.identifier)
        tableView.register(TotalAmountTableViewCell.self, forCellReuseIdentifier: TotalAmountTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()
    
    let totalAmountDescriptionLabel: UILabel = {
        let totalAmountLabel = UILabel()
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.text = "총 정산 내역"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        totalAmountLabel.textColor = .black
        return totalAmountLabel
    }()

    private lazy var totalAmountLabel: UILabel = {
        let totalAmount = UILabel()
        totalAmount.translatesAutoresizingMaskIntoConstraints = false
        totalAmount.textColor = .designSystem(.mainBlue)
        totalAmount.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        totalAmount.attributedText = makeAtrributedString(money: 120000, fontSize: 18, wonColor: .black)
        return totalAmount
    }()

    
    private let progressTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.register(DetailProgressTableViewCell.self, forCellReuseIdentifier: DetailProgressTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        return tableView
    }()

    
    private lazy  var closeButton: DWButton = {
        let cloasedButton = DWButton.create(.xlarge50)
        cloasedButton.translatesAutoresizingMaskIntoConstraints = false
        cloasedButton.title = "닫기"
        cloasedButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        return cloasedButton
    }()

    var viewModel: SentMoneyMoreDetailViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.allowsSelection = false
        detailTableView.showsVerticalScrollIndicator = false
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        print(viewModel?.totalAmount)
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        print(viewModel?.sentMoneyList)
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        print(viewModel?.myMoneyDetailInfoList)
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        render()
    }

    
    func render() {
        view.addSubview(mainTitle)
        mainTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        mainTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        view.addSubview(detailTableView)
        detailTableView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 30).isActive = true
        detailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        
        view.addSubview(closeButton)
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
    }
    
    @objc func dismissSheet() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SentMoneyMoreDetailViewController: UITableViewDataSource {
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.sentMoneyList.count ?? 0) + (viewModel?.myMoneyDetailInfoList.count ?? 0) + 1
    }

    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return .init() }

        if indexPath.row < viewModel.sentMoneyList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: SentMoneyTableViewCell.identifier, for: indexPath) as! SentMoneyTableViewCell
            cell.configure(myPayment: viewModel.sentMoneyList[indexPath.row])
            return cell
        }
        
        if indexPath.row == viewModel.sentMoneyList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountTableViewCell.identifier, for: indexPath) as! TotalAmountTableViewCell
            cell.configure(totalAmount: viewModel.total)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailProgressTableViewCell.identifier, for: indexPath) as! DetailProgressTableViewCell
        cell.configure(myData: viewModel.myMoneyDetailInfoList[indexPath.row - viewModel.sentMoneyList.count - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < (viewModel?.sentMoneyList.count ?? 0 ){
            return 70
        }
        return 120
    }
}
