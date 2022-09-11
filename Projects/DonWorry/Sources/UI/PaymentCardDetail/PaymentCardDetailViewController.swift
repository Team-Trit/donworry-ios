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

final class PaymentCardDetailViewController: BaseViewController {
    
    private let viewModel: PaymentCardDetailViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: PaymentCardDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var navigationBar = DWNavigationBar(title: viewModel.paymentCardName)
    
    private let priceBigContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let priceSmallContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.grayF6F6F6)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let attendacneBigContainerView: UIView = {
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
        button.setWidth(width: 16)
        button.setHeight(height: 22)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(editPrice), for: .touchUpInside)
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
    
    private let fileBigContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
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
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    @objc private func editPrice() {
        let paymentCardAmountEditViewController = PaymentCardAmountEditViewController(editType: .update)
        navigationController?.pushViewController(paymentCardAmountEditViewController, animated: true)
    }
    
    @objc private func didTapBottomButton() {
        
        if viewModel.isAdmin {
            let alert = UIAlertController(title: "정산카드를 삭제합니다.", message:
                                            "지금 삭제하시면 현재까지\n등록된 내용이 삭제됩니다.", preferredStyle: .alert)
            alert.view.tintColor = .black
            alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont.designSystem(weight: .regular, size: ._13), NSAttributedString.Key.foregroundColor : UIColor.designSystem(.gray696969)]), forKey: "attributedMessage")
            
            let action = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                self.viewModel.deletePaymentCard()
                self.navigationController?.popViewController(animated: true)
            })
            let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            viewModel.toggleAttendance()
            if viewModel.isAttended {
                bottomButton.setTitle("참석 완료", for: .normal)
                bottomButton.backgroundColor = .designSystem(.grayC5C5C5)
            } else {
                bottomButton.setTitle("참석 확인", for: .normal)
                bottomButton.backgroundColor = .designSystem(.mainBlue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
    
    private func attributes() {
        attendanceLabel.text = "참여자 : \(viewModel.numOfUsers)명"
        priceLabel.text = viewModel.totalAmountString
        if viewModel.isAdmin {
            editButton.isHidden = false
            bottomButton.setTitle("삭제하기", for: .normal)
            bottomButton.backgroundColor = .designSystem(.redTopGradient)
        } else {
            editButton.isHidden = true
            if viewModel.isAttended {
                bottomButton.setTitle("참석 완료", for: .normal)
                bottomButton.backgroundColor = .designSystem(.grayC5C5C5)
            } else {
                bottomButton.setTitle("참석 확인", for: .normal)
                bottomButton.backgroundColor = .designSystem(.mainBlue)
            }
        }
    }
    func bind(reactor: PaymentCardDetailViewReactor) {
    }
}

//MARK: Layout
extension PaymentCardDetailViewController {
    private func bind() {
        
        navigationBar.leftItem.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.$paymentCard
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fileCollectionView.reloadData()
                self?.attributes()
            }
            .store(in: &cancelBag)
    }
    
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
        totalBottomView.addSubview(priceBigContainerView)
        priceBigContainerView.anchor(top: spacingView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 19, paddingLeft: 25, paddingRight: 25)
        
        priceBigContainerView.addSubview(staticPriceLabel)
        staticPriceLabel.anchor(top: priceBigContainerView.topAnchor, left: priceBigContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        priceBigContainerView.addSubview(priceSmallContainerView)
        priceSmallContainerView.anchor(top: staticPriceLabel.bottomAnchor, left: priceBigContainerView.leftAnchor, bottom: priceBigContainerView.bottomAnchor, right: priceBigContainerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)
        
        let PriceHstack = UIStackView(arrangedSubviews: [priceLabel, editButton])
        priceSmallContainerView.addSubview(PriceHstack)
        PriceHstack.anchor(top: priceSmallContainerView.topAnchor, left: priceSmallContainerView.leftAnchor, bottom: priceSmallContainerView.bottomAnchor,right: priceSmallContainerView.rightAnchor, paddingTop: 14, paddingLeft: 18, paddingBottom: 14, paddingRight: 18)
        PriceHstack.centerY(inView: priceSmallContainerView)
        
        totalBottomView.addSubview(attendacneBigContainerView)
        attendacneBigContainerView.anchor(top: priceBigContainerView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingRight: 25)
        
        attendacneBigContainerView.addSubview(attendanceLabel)
        attendanceLabel.anchor(top: attendacneBigContainerView.topAnchor, left: attendacneBigContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        attendacneBigContainerView.addSubview(attendanceCollectionView)
        attendanceCollectionView.anchor(top: attendanceLabel.bottomAnchor, left: attendacneBigContainerView.leftAnchor, bottom: attendacneBigContainerView.bottomAnchor, right: attendacneBigContainerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 20, paddingRight: 0, height: 75)
        
        totalBottomView.addSubview(fileBigContainerView)
        fileBigContainerView.anchor(top: attendacneBigContainerView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingRight: 25)
        
        fileBigContainerView.addSubview(staticPictureLabel)
        staticPictureLabel.anchor(top: fileBigContainerView.topAnchor, left: fileBigContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        fileBigContainerView.addSubview(fileCollectionView)
        fileCollectionView.anchor(top: staticPictureLabel.bottomAnchor, left: fileBigContainerView.leftAnchor, bottom: fileBigContainerView.bottomAnchor, right: fileBigContainerView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 20, paddingRight: 15, height: 84)
        
        totalBottomView.addSubview(bottomButton)
        bottomButton.anchor(left: totalBottomView.leftAnchor, bottom: totalBottomView.bottomAnchor, right: totalBottomView.rightAnchor, paddingLeft: 24, paddingBottom: 50, paddingRight: 24, height: 50)
    }
}

//MARK: CollectionView
extension PaymentCardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case attendanceCollectionView:
            return viewModel.numOfUsers
        case fileCollectionView:
            return viewModel.imageUrlStrings.count
            //MARK: 추후 사진 수정시 이용됩니다
//            return cameraImageArray.count
//            if cameraImageArray.count == 0 {
//                return viewModel.numOfFilesWhenNoImages
//            } else if cameraImageArray.count == 3 {
//                return 3
//            } else {
//                return viewModel.isAdmin ? cameraImageArray.count + 1 : cameraImageArray.count
//            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case attendanceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceCollectionViewCell.cellID, for: indexPath) as? AttendanceCollectionViewCell else { return UICollectionViewCell() }
            cell.user = viewModel.userCollectionViewAt(indexPath.row)
            return cell
        case fileCollectionView:
            //MARK: 추후 사진 수정시 이용됩니다
//            if viewModel.isAdmin {
//                if cameraImageArray.count == 3 {
//                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
//                    cell.FileCollectionViewCellDelegate = self
//                    cell.container.image = cameraImageArray[indexPath.row]
//                    cell.deleteCircle.tag = indexPath.row
//                    return cell
//                } else {
//                    if indexPath.row == 0 {
//                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileAddCollectionViewCell.cellID, for: indexPath) as? FileAddCollectionViewCell else { return UICollectionViewCell() }
//                        return cell
//                    } else {
//                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
//                        cell.FileCollectionViewCellDelegate = self
//                        cell.container.image = cameraImageArray[(indexPath.row - 1)]
//                        cell.deleteCircle.tag = (indexPath.row - 1)
//                        return cell
//                    }
//                }
//            } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
            cell.FileCollectionViewCellDelegate = self
            cell.imageUrl = viewModel.imageUrlStrings[indexPath.row]
            cell.deleteCircle.isHidden = true
            return cell
//            }
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case attendanceCollectionView:
            guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceCollectionViewCell.cellID, for: indexPath) as? AttendanceCollectionViewCell else { return }
            //MARK: 추후 사진 수정시 이용됩니다
        case fileCollectionView:
//            guard viewModel.isAdmin else { return }
            guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return }
            let detailImageViewController = DetailImageViewController()
            detailImageViewController.imageUrl = viewModel.imageUrlStrings[indexPath.row]
            present(detailImageViewController, animated: true)
            //MARK: 추후 사진 수정시 이용됩니다
//            if cameraImageArray.count < 3 && indexPath.row == 0 {
//                showPhotoPicker()
//            }
        default:
            break
        }
    }
    
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
}

extension PaymentCardDetailViewController: FileCollectionViewCellDelegate {
    func deletePhoto() {
        DispatchQueue.main.async {
            self.fileCollectionView.reloadData()
        }
    }
}
//MARK: 추후 사진 수정시 이용됩니다
//extension PaymentCardDetailViewController: PHPickerViewControllerDelegate{
//
//    func showPhotoPicker() {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 3
//        let phPickerVC = PHPickerViewController(configuration: config)
//        phPickerVC.delegate = self
//        self.present(phPickerVC, animated: true)
//    }
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        dismiss(animated: true)
//        var images = [UIImage]()
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self){ object,
//                error in
//                if let image = object as? UIImage {
//                    images.append(image)
//                }
//                for image in images {
//                    if cameraImageArray.count == 3 {
//                        cameraImageArray[0] = image
//                    }
//                    else {
//                        cameraImageArray += [image]
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.fileCollectionView.reloadData()
//                }
//
//            }
//        }
//    }
//}

