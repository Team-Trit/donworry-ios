////
////  PaymentCardIconEditViewController.swift
////  App
////
////  Created by Chanhee Jeong on 2022/08/18.
////  Copyright (c) 2022 Tr-iT. All rights reserved.
////
//
//import UIKit
//import BaseArchitecture
//import ReactorKit
//import RxCocoa
//import RxSwift
//import DesignSystem
//
//
//final class PaymentCardIconEditViewController: BaseViewController, View {
//
//    private struct Catogory {
//        let iconName: String
//    }
//    private var selectedIcon: String = ""
//    private let icons: [Catogory] = [Catogory(iconName: "ic_chicken"),
//                                     Catogory(iconName: "ic_cup"),
//                                     Catogory(iconName: "ic_wine"),
//                                     Catogory(iconName: "ic_shopping_cart"),
//                                     Catogory(iconName: "ic_video"),
//                                     Catogory(iconName: "ic_spoon_knife"),
//                                     Catogory(iconName: "ic_cake"),
//                                     Catogory(iconName: "ic_gas_station"),
//                                     Catogory(iconName: "ic_icecream")]
//
//    // MARK: - Views
//    // TODO: Navigation title 설정해주기
//    private lazy var navigationBar = CustomNavigationBar()
//    private lazy var titleLabel: UILabel = {
//        $0.text = "정산내역 아이콘을\n선택해주세요"
//        $0.numberOfLines = 2
//        $0.setLineSpacing(spacing: 10.0)
//        $0.font = .designSystem(weight: .heavy, size: ._25)
//        return $0
//    }(UILabel())
//
////    private lazy var nextButton = LargeButton(type: .next)
//
//    private lazy var iconCollectionView: UICollectionView = {
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollecionViewLayout())
//        cv.isScrollEnabled = false
//        return cv
//    }()
//
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
//        setUI()
//    }
//
//    // MARK: - Binding
//    func bind(reactor: PaymentCardIconEditViewReactor) {
//        //binding here
//    }
//
//}
//
//// MARK: - setUI
//
//extension PaymentCardIconEditViewController {
//
//    private func setUI() {
//        view.backgroundColor = .designSystem(.white)
//        view.addSubviews(navigationBar, titleLabel, nextButton, iconCollectionView)
//
//        navigationBar.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//        }
//
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
//            $0.leading.trailing.equalToSuperview().inset(25)
//        }
//
//        nextButton.snp.makeConstraints {
//            $0.leading.trailing.bottom.equalToSuperview()
//        }
//
//        iconCollectionView.delegate = self
//        iconCollectionView.dataSource = self
//        iconCollectionView.register(PaymentIconCell.self, forCellWithReuseIdentifier: "PaymentIconCell")
//
//        iconCollectionView.snp.makeConstraints {
//            $0.width.equalTo(300)
//            $0.top.equalTo(titleLabel.snp.bottom).offset(57.5)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
//            $0.leading.trailing.equalToSuperview().inset(25)
//        }
//    }
//}
//
//
//// MARK: - CollectionView
//
//extension PaymentCardIconEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    private func createCollecionViewLayout() -> UICollectionViewCompositionalLayout{
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(102), heightDimension: .absolute(102))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(102))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
//        group.interItemSpacing = .fixed(16)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = CGFloat(16)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 9
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentIconCell", for: indexPath) as? PaymentIconCell else { return UICollectionViewCell() }
//        cell.configure(with: icons[indexPath.row].iconName)
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        // TODO: 선택된 셀 다루기
//        selectedIcon = icons[indexPath.row].iconName
//        print("선택된 셀 : \(selectedIcon)")
//    }
//
//}
