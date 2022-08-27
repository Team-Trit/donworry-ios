//
//  PaymentCardDetailViewController.swift
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
import DesignSystem
import Models

class abc: UIViewController {
    
    override func viewDidLoad() {
//        self.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("qwe", for: .normal)
        view.addSubview(button)
        button.centerX(inView: view)
        button.centerY(inView: view)
        button.addTarget(self, action: #selector(abb), for: .touchUpInside)
    }
    @objc fileprivate func abb() {
        let vc = PaymentCardDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// anchor2 지우기
final class PaymentCardDetailViewController: BaseViewController, View {

    fileprivate var backButton: UIButton = {
        let button = UIButton(type: .system)
        
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold)
        let boldSearch = UIImage(systemName: "chevron.left", withConfiguration: boldConfig)
        button.setImage(boldSearch, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    fileprivate let priceBigContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    fileprivate let priceSmallContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.grayF6F6F6)
        view.layer.cornerRadius = 15
        return view
    }()
    
    fileprivate let attendacneBigContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    fileprivate let staticPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.text = "결제금액"
        label.textColor = .black
        return label
    }()
    
    fileprivate let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.text = "102,000원"
        label.textColor = .black
        return label
    }()
    
    fileprivate var editButton: UIButton = {
        let button = UIButton()
        button.setWidth(width: 16)
        button.setHeight(height: 22)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .designSystem(.gray757474)
//        button.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        return button
    }()
    
    fileprivate let attendanceLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
//        label.text = "참석자: 7명"
        label.textColor = .black
        return label
    }()
    
    private let attendanceCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let view = UICollectionViewFlowLayout()
        view.minimumLineSpacing = 17
        view.scrollDirection = .horizontal
        return view
      }()
    
    private lazy var attendanceCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: attendanceCollectionViewFlowLayout)
        view.showsHorizontalScrollIndicator = false
        view.register(attendanceCollectionViewCell.self, forCellWithReuseIdentifier: attendanceCollectionViewCell.cellID)
        view.layer.cornerRadius = 16
        view.dataSource = self
        view.delegate = self
      return view
    }()
    
    fileprivate let staticPictureLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.text = "첨부 사진"
        label.textColor = .black
        return label
    }()
    
    var users: [User] = [User.dummyUser1, User.dummyUser2, User.dummyUser3, User.dummyUser4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
        configNavigationBar()
    }
    
    

    private func configNavigationBar() {
        
        navigationItem.title = "유쓰네 택시"
        navigationItem.hidesBackButton = true
        
        let backEmptyView = UIView()
        backEmptyView.setHeight(height: 5)
        
        let backButtonContainer = UIStackView(arrangedSubviews: [backButton, backEmptyView])
        backButtonContainer.axis = .vertical
//
        let backEmptyViewForHstack = UIView()
        backEmptyViewForHstack.setWidth(width: 7)
//
        let backButtonContainerForHstack = UIStackView(arrangedSubviews: [backEmptyViewForHstack, backButtonContainer])

//        cancelButtonContainer.spacing = Constants.betweenNumberAndLabel
//        let leftBarbutton = UIBarButtonItem(customView: cancelButtonContainer)
//        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButtonContainer)]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButtonContainerForHstack)]
        backButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
    }
    
    @objc fileprivate func popView() {
        navigationController?.popViewController(animated: true)
    }
    private func attributes() {
        attendanceLabel.text = "참여자 : \(users.count)명"
//        view.backgroundColor = .designSystem(.grayF6F6F6)
        
    }

    
    
    func bind(reactor: PaymentCardDetailViewReactor) {
        //binding here
    }

}

// MARK: setUI

extension PaymentCardDetailViewController {
    private func layout() {
        let totalTopView = UIView()
        view.addSubview(totalTopView)
        totalTopView.anchor2(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        totalTopView.backgroundColor = .white
        
        let totalBottomView = UIView()
        view.addSubview(totalBottomView)
        totalBottomView.anchor2(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        totalBottomView.backgroundColor = .designSystem(.grayF6F6F6)
        
        let spacingView = UIView()
        totalBottomView.addSubview(spacingView)
        spacingView.anchor2(top: totalBottomView.topAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 5)
        spacingView.backgroundColor = .white
        
        
        totalBottomView.addSubview(priceBigContainerView)
        priceBigContainerView.anchor2(top: spacingView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 19, paddingLeft: 25, paddingRight: 25)
        
        priceBigContainerView.addSubview(staticPriceLabel)
        staticPriceLabel.anchor2(top: priceBigContainerView.topAnchor, left: priceBigContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        priceBigContainerView.addSubview(priceSmallContainerView)
        priceSmallContainerView.anchor2(top: staticPriceLabel.bottomAnchor, left: priceBigContainerView.leftAnchor, bottom: priceBigContainerView.bottomAnchor, right: priceBigContainerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)
        
        let PriceHstack = UIStackView(arrangedSubviews: [priceLabel, editButton])
        priceSmallContainerView.addSubview(PriceHstack)
        PriceHstack.anchor2(top: priceSmallContainerView.topAnchor, left: priceSmallContainerView.leftAnchor, bottom: priceSmallContainerView.bottomAnchor,right: priceSmallContainerView.rightAnchor, paddingTop: 14, paddingLeft: 18, paddingBottom: 14, paddingRight: 18)
        PriceHstack.centerY(inView: priceSmallContainerView)
        
        totalBottomView.addSubview(attendacneBigContainerView)
        attendacneBigContainerView.anchor2(top: priceBigContainerView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingRight: 25)
        
        attendacneBigContainerView.addSubview(attendanceLabel)
        attendanceLabel.anchor2(top: attendacneBigContainerView.topAnchor, left: attendacneBigContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        attendacneBigContainerView.addSubview(attendanceCollectionView)
        attendanceCollectionView.anchor2(top: attendanceLabel.bottomAnchor, left: attendacneBigContainerView.leftAnchor, bottom: attendacneBigContainerView.bottomAnchor, right: attendacneBigContainerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 20, paddingRight: 0, height: 75)
        
    }
}

extension PaymentCardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: attendanceCollectionViewCell.cellID, for: indexPath) as? attendanceCollectionViewCell else { return UICollectionViewCell() }
        cell.user = users[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 48
        let height: CGFloat = 75
        return CGSize(width: width, height: height)
    }
    
}

extension UIView {
    // layout 하는 함수
    func anchor2(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {

        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true

        if let left = leftAnchor {
            anchor2(left: left, paddingLeft: paddingLeft)
        }
    }

    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

}

extension UIImageView {
    func load2(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
