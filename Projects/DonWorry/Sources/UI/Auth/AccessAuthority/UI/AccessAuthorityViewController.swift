//
//  AccessAuthorityViewController.swift
//  App
//
//  Created by uiskim on 2022/09/04.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift
import DesignSystem


final class AccessAuthorityViewController: BaseViewController {
    
    let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.font = .designSystem(weight: .regular, size: ._15)
        subTitle.textColor = .black
        subTitle.text = "정산내역 입력을 위해서"
        subTitle.textAlignment = .center
        return subTitle
    }()
    
    let mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.font = .designSystem(weight: .heavy, size: ._25)
        mainTitle.textColor = .black
        mainTitle.text = "접근권한 설정이 \n 필요합니다."
        mainTitle.numberOfLines = 2
        mainTitle.textAlignment = .center
        return mainTitle
    }()
    
    let seperateLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .designSystem(.grayF6F6F6)
        return line
    }()
    
    
    let alertInfo: AccessAuthorityInfoView = {
        let alertInfo = AccessAuthorityInfoView()
        alertInfo.translatesAutoresizingMaskIntoConstraints = false
        alertInfo.configure(image: "clock", title: "(선택) 알림", subTitle: "정산시작, 정산완료, 재촉알림")
        return alertInfo
    }()
    
    let photoInfo: AccessAuthorityInfoView = {
        let photoInfo = AccessAuthorityInfoView()
        photoInfo.translatesAutoresizingMaskIntoConstraints = false
        photoInfo.configure(image: "image", title: "(선택) 사진", subTitle: "정산카드 증빙 자료 첨부")
        return photoInfo
    }()
    
    let cameraInfo: AccessAuthorityInfoView = {
        let cameraInfo = AccessAuthorityInfoView()
        cameraInfo.translatesAutoresizingMaskIntoConstraints = false
        cameraInfo.configure(image: "camera", title: "(선택) 카메라", subTitle: "정산카드 증빙 자료 촬영")
        return cameraInfo
    }()
    
    let nextButton: DWButton = {
        let nextButton = DWButton.create(.xlarge50)
        nextButton.title = "허용하고 시작"
        return nextButton
    }()
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
}

extension AccessAuthorityViewController {

    private func attributes() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubviews(subTitle, mainTitle)
        view.addSubview(seperateLine)
        view.addSubviews(alertInfo, photoInfo, cameraInfo)
        view.addSubview(nextButton)
        subTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 101).isActive = true
        subTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitle.widthAnchor.constraint(equalToConstant: 302).isActive = true
        subTitle.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        mainTitle.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 10).isActive = true
        mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainTitle.widthAnchor.constraint(equalToConstant: 302).isActive = true
        mainTitle.heightAnchor.constraint(equalToConstant: 67).isActive = true
        
        seperateLine.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 30).isActive = true
        seperateLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        seperateLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        alertInfo.topAnchor.constraint(equalTo: seperateLine.bottomAnchor, constant: 50).isActive = true
        alertInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alertInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alertInfo.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        photoInfo.topAnchor.constraint(equalTo: alertInfo.bottomAnchor, constant: 30).isActive = true
        photoInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoInfo.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        cameraInfo.topAnchor.constraint(equalTo: photoInfo.bottomAnchor, constant: 30).isActive = true
        cameraInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cameraInfo.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true

    }
}
