//
//  ParticipatePaymentCardViewController.swift
//  App
//
//  Created by Hankyu Lee on 2022/08/27.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import Models
import DesignSystem
import Combine

final class ParticipatePaymentCardViewController: BaseViewController, View {
    
    let viewModel = ParticipatePaymentCardViewModel()
    private var cancelBag = Set<AnyCancellable>()
    
    fileprivate var numberOfselectedCardsLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._17)
        label.textColor = .designSystem(.mainBlue)
        return label
    }()
    
    fileprivate var cancleSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택해제", for: .normal)
        button.tintColor = .designSystem(.black)
        button.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    fileprivate var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    fileprivate let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let view = UICollectionViewFlowLayout()
        view.minimumLineSpacing = Constants.collectionViewMinLineSpacing
        view.headerReferenceSize = .init(width: 100, height: 38)
        view.scrollDirection = .vertical
        return view
      }()
    
    fileprivate lazy var participateCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.showsHorizontalScrollIndicator = false
        view.register(ParticipateCollectionViewCell.self, forCellWithReuseIdentifier: ParticipateCollectionViewCell.cellID)
      return view
    }()
    
    private lazy var selectAllButton: UIButton = {
        let bt = DWButton.create(.halfMainBlue)
        bt.setTitle("모두 선택", for: .normal)
        bt.addTarget(self, action: #selector(selectAllCard), for: .touchUpInside)
        return bt
    }()
    
    private lazy var checkAttendanceButton: UIButton = {
        let bt = DWButton.create(.halfLightBlue)
        bt.setTitle("참석 확인", for: .normal)//AppleSDGothicNeo?
        bt.addTarget(self, action: #selector(checkAttendance), for: .touchUpInside)
        return bt
    }()
    
    @objc private func selectAllCard() {
        viewModel.checkAll()
    }
    
    @objc private func checkAttendance() {
        //TODO: 참석확인
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        combineBind()
        attributes()
        layout()
        configNavigationBar()
    }

    private func combineBind() {
        viewModel.$checkedIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.numberOfselectedCardsLabel.text = "\($0.count)"
                self?.participateCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    func bind(reactor: ParticipatePaymentCardViewReactor) {
        //binding here
    }

}

// MARK: setUI

extension ParticipatePaymentCardViewController {

    private func configNavigationBar() {
        
        navigationItem.title = "참석확인"
        //TODO: chckedCards viewmodel에서 받아야함
        numberOfselectedCardsLabel.text = "\(viewModel.numOfCheckedCards)"
        
        let cancelEmptyView = UIView()
        cancelEmptyView.setWidth(width: 4)
        
        let cancelButtonContainer = UIStackView(arrangedSubviews: [cancelEmptyView, cancelButton])
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        cancelButtonContainer.spacing = Constants.betweenNumberAndLabel
        let leftBarbutton = UIBarButtonItem(customView: cancelButtonContainer)
        navigationItem.leftBarButtonItem = leftBarbutton
        
        let selectEmptyView = UIView()
        selectEmptyView.setWidth(width: 4)
        
        let selectRelatedContainer = UIStackView(arrangedSubviews: [numberOfselectedCardsLabel, cancleSelectButton, selectEmptyView])
        cancleSelectButton.addTarget(self, action: #selector(cancelSelection), for: .touchUpInside)
        selectRelatedContainer.spacing = Constants.betweenNumberAndLabel
        
        let rightBarbutton = UIBarButtonItem(customView: selectRelatedContainer)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    private func attributes() {
        
        view.backgroundColor = .designSystem(.white)
        participateCollectionView.register(ParticipateCollectionViewCell.self, forCellWithReuseIdentifier: ParticipateCollectionViewCell.cellID)
        participateCollectionView.delegate = self
        participateCollectionView.dataSource = self
        participateCollectionView.showsVerticalScrollIndicator = false
    }

    private func layout() {
        view.addSubview(participateCollectionView)
        participateCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: Constants.collectionViewTopPadding, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        let bottomButtons = UIStackView(arrangedSubviews: [selectAllButton, checkAttendanceButton])
        bottomButtons.distribution = .fillEqually
        bottomButtons.spacing = 16
        view.addSubview(bottomButtons)
        bottomButtons.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 25, paddingBottom: 40, paddingRight: 25)
    }
}

extension ParticipatePaymentCardViewController {
    @objc fileprivate func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func cancelSelection() {
        viewModel.resetCheck()
    }
}

extension ParticipatePaymentCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfPaymentCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipateCollectionViewCell.cellID, for: indexPath) as? ParticipateCollectionViewCell else { return UICollectionViewCell() }
        cell.paymentCard = viewModel.paymentCardAt(indexPath.row)
        cell.isChecked =  viewModel.isCheckedAt(indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionViewWidth, height: Constants.collectionViewHeight)
    }
}

extension ParticipatePaymentCardViewController: CellCheckPress {
    func toggleCheckAt(_ id: Int) {
        viewModel.checkCardAt(id)
    }
}

extension ParticipatePaymentCardViewController {
    struct Constants {
        static let betweenNumberAndLabel: CGFloat = 4
        static let collectionViewMinLineSpacing: CGFloat = 12
        static let collectionViewTopPadding: CGFloat = 0
        static let collectionViewLeftPadding: CGFloat = 25
        static let collectionViewWidth: CGFloat = UIScreen.main.bounds.width - collectionViewLeftPadding * 2
        static let collectionViewHeight: CGFloat = 139
    }
}

