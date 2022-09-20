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
import PhotosUI
import Combine
import DonWorryExtensions

final class PaymentCardDetailViewController: BaseViewController, View {
    typealias Reactor = PaymentCardDetailViewReactor
    private lazy var navigationBar = DWNavigationBar(title: "")
    
    private let priceLabelOuterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let priceLabelInnerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.grayF6F6F6)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let attendacneContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let staticPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.text = "결제금액"
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.textColor = .black
        return label
    }()
    
    lazy private var editButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setWidth(width: 16)
        button.setHeight(height: 22)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .designSystem(.gray757474)
        return button
    }()
    
    private let attendanceLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
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
        view.register(AttendanceCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceCollectionViewCell.cellID)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let staticPictureLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.text = "첨부 사진"
        label.textColor = .black
        return label
    }()
    
    private let filesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let noFilesLabel: UILabel = {
        let label = UILabel()
        label.text = "첨부 내역이 없습니다."
        label.font = .designSystem(weight: .regular, size: ._13)
        label.textColor = .designSystem(.gray818181)
        return label
    }()
    
    private let fileCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let view = UICollectionViewFlowLayout()
        view.minimumLineSpacing = 15
        view.scrollDirection = .horizontal
        return view
    }()
    
    private lazy var fileCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: fileCollectionViewFlowLayout)
        view.showsHorizontalScrollIndicator = false
        view.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: FileCollectionViewCell.cellID)
        view.register(FileAddCollectionViewCell.self, forCellWithReuseIdentifier: FileAddCollectionViewCell.cellID)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var bottomButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.setTitle("참석 완료", for: .disabled)
        $0.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
        return $0
    }(UIButton())

    var buttonType: ButtonType = .participate {
        didSet {
            bottomButton.setTitle(buttonType.title, for: .normal)
            bottomButton.setBackgroundColor(buttonType.buttonColor!, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func dispatch(to reactor: Reactor) {
        self.fileCollectionView.rx.itemSelected
            .map { .imageCellButton(reactor.currentState.imgURLs[$0.row] ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: Reactor) {
        
        dispatch(to: reactor)
        
        self.rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.bottomButton.rx.tap.map { .didTapBottomButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.spaceStatus }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.bottomButton.isHidden = !($0 == "OPEN")
            }).disposed(by: disposeBag)

        reactor.state.map { $0.isCardAdmin }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isCardAdmin in
                self?.buttonType = isCardAdmin ? .delete : .participate
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.isButtonEnabled }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isButtonEnabled in
                self?.bottomButton.isEnabled = isButtonEnabled
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.cardName }
            .bind(to: navigationBar.titleLabel!.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.amount }
            .observe(on: MainScheduler.instance)
            .compactMap { Formatter.amountFormatter.string(from: NSNumber(value: $0)) }
            .subscribe(onNext: { [weak self] amountText in
                self?.priceLabel.text = amountText + "원"
            }, onError: { [weak self] _ in
                self?.priceLabel.text = "0원"
            }).disposed(by: disposeBag)

        reactor.state.map { $0.participatedUsers }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] participatedUsers in
                self?.attendanceLabel.text = "참여자 \(participatedUsers.count)"
                self?.attendanceCollectionView.reloadData()
            }).disposed(by: disposeBag)

        reactor.state.map { $0.imgURLs }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if $0.count == 0 {
                    self?.showNoFilesMent()
                }
                self?.fileCollectionView.reloadData()
            }).disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
    }
}

// MARK: Routing

extension PaymentCardDetailViewController {
    func move(to step: PaymentCardDetailStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .editAmount:
            break
        case .showImage(let imageUrl):
            let detailImageViewController = DetailImageViewController()
            detailImageViewController.imageUrl = imageUrl
            detailImageViewController.modalPresentationStyle = .fullScreen
            present(detailImageViewController, animated: true)
        }
    }
}

extension PaymentCardDetailViewController {

    private func layout() {
        
        let totalBottomView = UIView()
        view.addSubview(totalBottomView)
        totalBottomView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        totalBottomView.backgroundColor = .designSystem(.white)
        totalBottomView.addSubview(navigationBar)
        
        navigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        let colorView = UIView()
        totalBottomView.addSubview(colorView)
        colorView.anchor(top: navigationBar.bottomAnchor, left: view.leftAnchor.self, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        colorView.backgroundColor = .designSystem(.grayF6F6F6)
        
        let spacingView = UIView()
        totalBottomView.addSubview(spacingView)
        spacingView.anchor(top: navigationBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 5)
        spacingView.backgroundColor = .designSystem(.white)
        totalBottomView.addSubview(priceLabelOuterContainerView)
        priceLabelOuterContainerView.anchor(top: spacingView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 19, paddingLeft: 25, paddingRight: 25)
        
        priceLabelOuterContainerView.addSubview(staticPriceLabel)
        staticPriceLabel.anchor(top: priceLabelOuterContainerView.topAnchor, left: priceLabelOuterContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        priceLabelOuterContainerView.addSubview(priceLabelInnerContainerView)
        priceLabelInnerContainerView.anchor(top: staticPriceLabel.bottomAnchor, left: priceLabelOuterContainerView.leftAnchor, bottom: priceLabelOuterContainerView.bottomAnchor, right: priceLabelOuterContainerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)
        
        let PriceHstack = UIStackView(arrangedSubviews: [priceLabel, editButton])
        priceLabelInnerContainerView.addSubview(PriceHstack)
        PriceHstack.anchor(top: priceLabelInnerContainerView.topAnchor, left: priceLabelInnerContainerView.leftAnchor, bottom: priceLabelInnerContainerView.bottomAnchor,right: priceLabelInnerContainerView.rightAnchor, paddingTop: 14, paddingLeft: 18, paddingBottom: 14, paddingRight: 18)
        PriceHstack.centerY(inView: priceLabelInnerContainerView)
        
        totalBottomView.addSubview(attendacneContainerView)
        attendacneContainerView.anchor(top: priceLabelOuterContainerView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingRight: 25)
        
        attendacneContainerView.addSubview(attendanceLabel)
        attendanceLabel.anchor(top: attendacneContainerView.topAnchor, left: attendacneContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        attendacneContainerView.addSubview(attendanceCollectionView)
        attendanceCollectionView.anchor(top: attendanceLabel.bottomAnchor, left: attendacneContainerView.leftAnchor, bottom: attendacneContainerView.bottomAnchor, right: attendacneContainerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 20, paddingRight: 0, height: 75)
        
        totalBottomView.addSubview(filesContainerView)
        filesContainerView.anchor(top: attendacneContainerView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingRight: 25)
        
        filesContainerView.addSubview(staticPictureLabel)
        staticPictureLabel.anchor(top: filesContainerView.topAnchor, left: filesContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        filesContainerView.addSubview(fileCollectionView)
        fileCollectionView.anchor(top: staticPictureLabel.bottomAnchor, left: filesContainerView.leftAnchor, bottom: filesContainerView.bottomAnchor, right: filesContainerView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 20, paddingRight: 15, height: 84)
        
        totalBottomView.addSubview(bottomButton)
        bottomButton.anchor(left: totalBottomView.leftAnchor, bottom: totalBottomView.bottomAnchor, right: totalBottomView.rightAnchor, paddingLeft: 24, paddingBottom: 50, paddingRight: 24, height: 50)

        bottomButton.roundCorners(25)
    }
}

//MARK: CollectionView
extension PaymentCardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let state = reactor?.currentState else { return 0 }
        switch collectionView {
        case attendanceCollectionView:
            return state.participatedUsers.count
        case fileCollectionView:
            return state.imgURLs.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let state = reactor?.currentState else { return .init() }
        switch collectionView {
        case attendanceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceCollectionViewCell.cellID, for: indexPath) as? AttendanceCollectionViewCell else { return UICollectionViewCell() }
            cell.viewModel = state.participatedUsers[indexPath.item]
            return cell
        case fileCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
            cell.imageUrl = state.imgURLs[indexPath.item]
            cell.deleteButton.isHidden = true
            return cell
        default: return UICollectionViewCell()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch collectionView {
//        case fileCollectionView:
//            guard let cell = collectionView.cellForItem(at: indexPath) as? FileCollectionViewCell else {
//                return
//            }
//            let detailImageViewController = DetailImageViewController()
//            detailImageViewController.imageUrl = cell.imageUrl
//            present(detailImageViewController, animated: true)
//        default:
//            break
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case attendanceCollectionView:
            let width: CGFloat = 48
            let height: CGFloat = 75
            return CGSize(width: width, height: height)
        case fileCollectionView:
            return CGSize(width: 84, height: 84)
        default:
            return CGSize(width: 84, height: 84)
        }
    }
    
    private func showNoFilesMent() {
        self.filesContainerView.addSubview(noFilesLabel)
        self.noFilesLabel.anchor(top: filesContainerView.topAnchor, left: filesContainerView.leftAnchor, bottom: filesContainerView.bottomAnchor, right: filesContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        noFilesLabel.textAlignment = .center
    }
}

extension PaymentCardDetailViewController {
    enum ButtonType {
        case delete
        case participate

        var title: String {
            switch self {
            case .delete:
                return "삭제하기"
            case .participate:
                return "참석 확인"
            }
        }

        var buttonColor: UIColor? {
            switch self {
            case .delete:
                return .designSystem(.redTopGradient)
            case .participate:
                return .designSystem(.mainBlue)
            }
        }
    }
}
