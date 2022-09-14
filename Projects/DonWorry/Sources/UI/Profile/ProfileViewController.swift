//
//  ProfileViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import PhotosUI
import UIKit

import BaseArchitecture
import DesignSystem
import DonWorryExtensions
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit


enum ProfileTableViewCellType {
    case user
    case account
    case service(String)
}

final class ProfileViewController: BaseViewController, View {
    typealias Reactor = ProfileViewReactor
    private var items: [ProfileTableViewCellType] = [
        .user,
        .account,
        .service("공지사항"),
        .service("이용약관"),
        .service("푸시설정")
    ]
    private lazy var navigationBar = DWNavigationBar()
    private lazy var profileTableView: ProfileTableView = {
        let v = ProfileTableView()
        v.dataSource = self
        v.delegate = self
        return v
    }()
    private lazy var inquiryButtonView = ServiceButtonView(frame: .zero, type: .inquiry)
    private lazy var questionButtonView = ServiceButtonView(frame: .zero, type: .question)
    private lazy var blogButtonView = ServiceButtonView(frame: .zero, type: .blog)
    private lazy var accountButtonStackView = AccountButtonStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension ProfileViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, profileTableView, inquiryButtonView, questionButtonView, blogButtonView, accountButtonStackView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().offset(-200)
        }
        
        inquiryButtonView.snp.makeConstraints { make in
            make.top.equalTo(profileTableView.snp.bottom).offset(25)
            make.trailing.equalTo(questionButtonView.snp.leading).offset(-50)
            make.width.height.equalTo(50)
        }
        
        questionButtonView.snp.makeConstraints { make in
            make.top.equalTo(profileTableView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        blogButtonView.snp.makeConstraints { make in
            make.top.equalTo(profileTableView.snp.bottom).offset(25)
            make.leading.equalTo(questionButtonView.snp.trailing).offset(50)
            make.width.height.equalTo(50)
        }
        
        accountButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileViewController {
    private func dispatch(to reactor: Reactor) {
        self.rx.viewWillAppear
            .map { _ in
                return Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        accountButtonStackView.logoutButton.rx.tap
            .map { Reactor.Action.pressLogoutButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        accountButtonStackView.deleteButton.rx.tap
            .map { Reactor.Action.pressAccountDeleteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.pressBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.pulse(\.$reload)
            .asDriver(onErrorJustReturn: ())
            .compactMap { $0 }
            .drive(onNext: { [weak self] in
                self?.profileTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: ProfileStep.none)
            .compactMap { $0 }
            .drive(onNext: { [weak self] in
                self?.route(to: $0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension ProfileViewController {
    private func route(to step: ProfileStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
            
        case .profileImageSheet:
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let choosePhotoAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                self.present(picker, animated: true)
            }
            let takePhotoAction = UIAlertAction(title: "사진 촬영", style: .default) { _ in
                let imgPickerController = UIImagePickerController()
                imgPickerController.fixCannotMoveEditingBox()
                imgPickerController.sourceType = .camera
                imgPickerController.allowsEditing = true
                imgPickerController.delegate = self
                
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    self.present(imgPickerController, animated: true)
                    
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                            guard let self = self else { return }
                                if granted {
                                    DispatchQueue.main.async {
                                        self.present(imgPickerController, animated: true)
                                    }
                                }
                            }
                    
                case .denied, .restricted:
                    let alert = UIAlertController(title: nil, message: "카메라 촬영 권한이 없습니다.\n카메라 권한을 허용해주세요.", preferredStyle: .alert)
                    let settingAction = UIAlertAction(title: "설정", style: .default) { _ in
                        // 설정으로 이동
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    
                    alert.addAction(settingAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                    
                @unknown default:
                    break
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            actionSheet.addAction(choosePhotoAction)
            actionSheet.addAction(takePhotoAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true)
            
        case .nicknameEdit:
            let vc = NicknameEditViewController()
            let reactor = NicknameEditViewReactor(userService: UserServiceImpl())
            vc.reactor = reactor
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .accountEdit:
            let vc = AccountEditViewController()
//            let reactor = AccountEditViewReactor()
//            vc.reactor = reactor
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .deleteAccountSheet:
            let alert = UIAlertController(title: "정말로 탈퇴하시겠습니까?", message: "탈퇴 시 회원님의 모든 정보가 삭제되고 이후 복구할 수 없습니다.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
                self.reactor?.action.onNext(.deleteAccount)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
            
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .user:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewUserCell.identifier, for: indexPath) as? ProfileTableViewUserCell {
                cell.imagePlusButton.rx.tap
                    .map { Reactor.Action.pressUpdateProfileImageButton }
                    .bind(to: reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                cell.editButton.rx.tap
                    .map {
                        return Reactor.Action.pressUpdateNickNameButton }
                    .bind(to: reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.imageURL }
                    .distinctUntilChanged()
                    .asDriver(onErrorJustReturn: "")
                    .drive(onNext: { imgURL in
                        if imgURL != "", let url = URL(string: imgURL) {
                            cell.profileImageView.kf.setImage(with: url)
                        } else {
                            cell.profileImageView.image = UIImage(.default_profile_image)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.nickname }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.nickNameLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
        case .account:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewAccountCell.identifier, for: indexPath) as? ProfileTableViewAccountCell {
                cell.editButton.rx.tap
                    .map { Reactor.Action.pressUpdateAccountButton }
                    .bind(to: reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.bank }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.bankLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.accountNumber }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.accountLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.accountHolder }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.holderLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
        case .service(let title):
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewServiceCell.identifier, for: indexPath) as? ProfileTableViewServiceCell {
                cell.titleLabel.text = title
                
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .user:
            return 130
        case .account:
            return 170
        case .service:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .user:
            guard let cell = cell as? ProfileTableViewUserCell else { return }
            cell.disposeBag = DisposeBag()
            
        case .account:
            guard let cell = cell as? ProfileTableViewAccountCell else { return }
            cell.disposeBag = DisposeBag()
            
        case .service(_):
            guard let cell = cell as? ProfileTableViewServiceCell else { return }
            cell.disposeBag = DisposeBag()
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let selectedPhoto = results.first?.itemProvider
        selectedPhoto?.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier, completionHandler: { url, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let imgURL = url?.absoluteString else { return }
            self.reactor?.action.onNext(.updateProfileImage(imgURL: imgURL))
        })
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        let imgName = UUID().uuidString+".jpeg"
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgName)
        let data = image.jpegData(compressionQuality: 0.3)! as NSData
        data.write(toFile: localPath, atomically: true)
        let imgURL = URL.init(fileURLWithPath: localPath).absoluteString
        self.reactor?.action.onNext(.updateProfileImage(imgURL: imgURL))
    }
}
