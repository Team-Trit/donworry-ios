//
//  FullSheetSentDetailViewController.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class FullSheetSentDetailViewController: UIViewController, UITableViewDelegate {
    
//    private let maxDimmedAlpha: CGFloat = 0.6
//    private let defaultContainerHeight: CGFloat = 400
//    private let dismissibleHeight: CGFloat = 300
//    private var currentContainerHeight: CGFloat = 400
//    private var containerViewHeightConstraint: NSLayoutConstraint?
//    private var containerViewBottomConstraint: NSLayoutConstraint?
//    private var confirmButtonBottomConstraint: NSLayoutConstraint?
    
    private let contentScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.backgroundColor = .red
            scrollView.showsVerticalScrollIndicator = false
            
            return scrollView
        }()
    
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
    
    private let closeButton: DWButton = {
        let cloasedButton = DWButton.create(.xlarge50)
        cloasedButton.translatesAutoresizingMaskIntoConstraints = false
        cloasedButton.title = "닫기"
        cloasedButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        return cloasedButton
    }()
    
//    private lazy var dimmedView: UIView = {
//        let v = UIView()
//        v.backgroundColor = .designSystem(.black)
//        v.alpha = 0
//        return v
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setupPanGesture()
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.allowsSelection = false
        detailTableView.showsVerticalScrollIndicator = false
        
        
        render()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        showDimmedView()
//        presentContainer()
//    }
    
    func render() {
        view.addSubview(mainTitle)
        mainTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        mainTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        view.addSubview(detailTableView)
        detailTableView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 30).isActive = true
        detailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        
        view.addSubviews(closeButton)
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
    }
    
    @objc func dismissSheet() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    private func setupPanGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
//        panGesture.delaysTouchesBegan = false
//        panGesture.delaysTouchesEnded = false
//        view.addGestureRecognizer(panGesture)
//    }
}

extension FullSheetSentDetailViewController: UITableViewDataSource {
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMoneyInfo.count + myMoneyDetailInfo.count + 1
    }

    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row < myMoneyInfo.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: SentMoneyTableViewCell.identifier, for: indexPath) as! SentMoneyTableViewCell
            cell.configure(icon: "flame.fill", myPayment: myMoneyInfo[indexPath.row])
            return cell
        }
        
        if indexPath.row == myMoneyInfo.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountTableViewCell.identifier, for: indexPath) as! TotalAmountTableViewCell
            cell.configure(totalAmount: 120000)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailProgressTableViewCell.identifier, for: indexPath) as! DetailProgressTableViewCell
        cell.configure(myData: myMoneyDetailInfo[indexPath.row - myMoneyInfo.count - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < myMoneyInfo.count {
            return 70
        }
        return 120
    }
}


//extension FullSheetSentDetailViewController {
//    private func showDimmedView() {
//        UIView.animate(withDuration: 0.4) {
//            self.dimmedView.alpha = self.maxDimmedAlpha
//        }
//    }
//    
//    private func presentContainer() {
//        UIView.animate(withDuration: 0.3) {
//            self.containerViewBottomConstraint?.constant = 0
//            self.confirmButtonBottomConstraint?.constant = -50
//            self.view.layoutIfNeeded()
//        }
//    }
//    private func dismissContainerView() {
//        UIView.animate(withDuration: 0.3) {
//            self.containerViewBottomConstraint?.constant = self.defaultContainerHeight
//            self.confirmButtonBottomConstraint?.constant = self.defaultContainerHeight
//            self.view.layoutIfNeeded()
//        }
//        
//        UIView.animate(withDuration: 0.4) {
//            self.dimmedView.alpha = 0
//        } completion: { _ in
//            self.dismiss(animated: false)
//        }
//    }
//    
//    private func animateContainerHeight(_ height: CGFloat) {
//        UIView.animate(withDuration: 0.4) {
//            self.containerViewHeightConstraint?.constant = height
//            self.view.layoutIfNeeded()
//        }
//        currentContainerHeight = height
//    }
//    
//    private func animateConfirmButtonHeight(_ height: CGFloat) {
//        UIView.animate(withDuration: 0.4) {
//            self.confirmButtonBottomConstraint?.constant = height
//            self.view.layoutIfNeeded()
//        }
//    }
//}
//
//extension FullSheetSentDetailViewController {
//    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//        let newContainerHeight = currentContainerHeight - translation.y
//        let newButtonHeight = translation.y - 50
//        
//        switch gesture.state {
//        case .changed:
//            containerViewHeightConstraint?.constant = newContainerHeight
//            confirmButtonBottomConstraint?.constant = newButtonHeight
//            view.layoutIfNeeded()
//        case .ended:
//            if newContainerHeight < dismissibleHeight {
//                self.dismissContainerView()
//            }
//            else {
//                self.animateContainerHeight(defaultContainerHeight)
//                self.animateConfirmButtonHeight(-50)
//            }
//        default:
//            break
//        }
//    }
//}
