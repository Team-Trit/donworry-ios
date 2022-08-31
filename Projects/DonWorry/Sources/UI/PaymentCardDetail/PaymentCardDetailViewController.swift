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

// MARK: - 도메인 로직 생기고 교체 합니다. || am sorry

var cameraImageArray = [UIImage(.ic_cake), UIImage(.ic_chicken)]

final class PaymentCardDetailViewController: BaseViewController, View {
    
    let viewModel = PaymentCardDetailViewModel()
    
    private lazy var navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        // TODO: Navigation bar title 설정해줘야합니다
        v.leftItem.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        return v
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
        label.textColor = .black
        return label
    }()
    
    lazy fileprivate var editButton: UIButton = {
        let button = UIButton()
        button.setWidth(width: 16)
        button.setHeight(height: 22)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(editPrice), for: .touchUpInside)
        button.tintColor = .designSystem(.gray757474)
        return button
    }()
    
    fileprivate let attendanceLabel: UILabel = {
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
    
    fileprivate let staticPictureLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._15)
        label.text = "첨부 사진"
        label.textColor = .black
        return label
    }()
    
    fileprivate let fileBigContainerView: UIView = {
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
        print("edit")
    }
    
    @objc private func didTapBottomButton() {
        
        if viewModel.isAdmin {
            let alert = UIAlertController(title: "정산카드를 삭제합니다.", message:
                                            "지금 삭제하시면 현재까지\n등록된 내용이 삭제됩니다.", preferredStyle: .alert)
            alert.view.tintColor = .black
            alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont.designSystem(weight: .regular, size: ._13), NSAttributedString.Key.foregroundColor : UIColor.designSystem(.gray696969)]), forKey: "attributedMessage")
            
            let action = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                //TODO: 삭제구현
                print("삭제")
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
        //binding here
    }
    
}

//MARK: Layout
extension PaymentCardDetailViewController {
    private func layout() {
        
        let totalBottomView = UIView()
        view.addSubview(totalBottomView)
        totalBottomView.anchor2(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        totalBottomView.backgroundColor = .designSystem(.grayF6F6F6)
        
        let spacingView =  CustomNavigationBar.init(title: viewModel.paymentCardName)
        totalBottomView.addSubview(spacingView)
        spacingView.anchor2(top: totalBottomView.topAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        //        spacingView.backgroundColor = .red
        
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
        
        totalBottomView.addSubview(fileBigContainerView)
        fileBigContainerView.anchor2(top: attendacneBigContainerView.bottomAnchor, left: totalBottomView.leftAnchor, right: totalBottomView.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingRight: 25)
        
        fileBigContainerView.addSubview(staticPictureLabel)
        staticPictureLabel.anchor2(top: fileBigContainerView.topAnchor, left: fileBigContainerView.leftAnchor, paddingTop: 15, paddingLeft: 13)
        
        fileBigContainerView.addSubview(fileCollectionView)
        fileCollectionView.anchor2(top: staticPictureLabel.bottomAnchor, left: fileBigContainerView.leftAnchor, bottom: fileBigContainerView.bottomAnchor, right: fileBigContainerView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 20, paddingRight: 15, height: 84)
        
        totalBottomView.addSubview(bottomButton)
        bottomButton.anchor2(left: totalBottomView.leftAnchor, bottom: totalBottomView.bottomAnchor, right: totalBottomView.rightAnchor, paddingLeft: 24, paddingBottom: 50, paddingRight: 24, height: 50)
    }
}

//MARK: CollectionView
extension PaymentCardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case attendanceCollectionView:
            return viewModel.numOfUsers
        case fileCollectionView:
            if cameraImageArray.count == 0 {
                return viewModel.numOfFilesWhenNoImages
            } else if cameraImageArray.count == 3 {
                return 3
            } else {
                return viewModel.isAdmin ? cameraImageArray.count + 1 : cameraImageArray.count
            }
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
            if viewModel.isAdmin {
                if cameraImageArray.count == 3 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
                    cell.FileCollectionViewCellDelegate = self
                    cell.container.image = cameraImageArray[indexPath.row]
                    cell.deleteCircle.tag = indexPath.row
                    return cell
                } else {
                    if indexPath.row == 0 {
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileAddCollectionViewCell.cellID, for: indexPath) as? FileAddCollectionViewCell else { return UICollectionViewCell() }
                        return cell
                    } else {
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
                        cell.FileCollectionViewCellDelegate = self
                        cell.container.image = cameraImageArray[(indexPath.row - 1)]
                        cell.deleteCircle.tag = (indexPath.row - 1)
                        return cell
                    }
                }
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return UICollectionViewCell() }
                cell.FileCollectionViewCellDelegate = self
                cell.container.image = cameraImageArray[(indexPath.row)]
                cell.deleteCircle.isHidden = true
                return cell
            }
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case attendanceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceCollectionViewCell.cellID, for: indexPath) as? AttendanceCollectionViewCell else { return }
        case fileCollectionView:
            guard viewModel.isAdmin else { return }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.cellID, for: indexPath) as? FileCollectionViewCell else { return }
            if cameraImageArray.count < 3 && indexPath.row == 0 {
                showPhotoPicker()
            }
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

extension PaymentCardDetailViewController: PHPickerViewControllerDelegate{
    
    func showPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        var images = [UIImage]()
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self){ object,
                error in
                if let image = object as? UIImage {
                    images.append(image)
                }
                for image in images {
                    if cameraImageArray.count == 3 {
                        cameraImageArray[0] = image
                    }
                    else {
                        cameraImageArray += [image]
                    }
                }
                DispatchQueue.main.async {
                    self.fileCollectionView.reloadData()
                }
                
            }
        }
    }
}

//MARK: 아래는 삭제될 부분입니다.
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
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
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

