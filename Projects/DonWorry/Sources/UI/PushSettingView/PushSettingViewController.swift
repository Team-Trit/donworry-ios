//
//  PushSettingViewController.swift
//  App
//
//  Created by uiskim on 2022/09/05.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift
import DesignSystem

struct Toggle {
    let main: String
    let sub: String
}

final class PushSettingViewController: BaseViewController {
    let toggleTitles: [Toggle] = [
        Toggle(main: "정산알림", sub: "정산시작, 정산완료, 재촉"),
        Toggle(main: "서비스 마케팅 알림", sub: "이벤트, 혜택 등")
    ]
    
    private lazy var navigationBar = DWNavigationBar(title: "")
    
    private let pushTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "푸시설정"
        title.textColor = .designSystem(.black)
        title.font = .designSystem(weight: .heavy, size: ._25)
        return title
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PushSettingTableViewCell.self, forCellReuseIdentifier: PushSettingTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        attributes()
        layout()
        requestNotificationPermission()
    }
    
    //MARK : - 알람설정 노티가뜨는뷰에 가져가면됨
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
            if didAllow {
                print("Push: 권한 허용")
            } else {
                print("Push: 권한 거부")
            }
        })
    }

    
}

extension PushSettingViewController {

    private func attributes() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubview(navigationBar)
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 61).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(pushTitle)
        pushTitle.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 31).isActive = true
        pushTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        pushTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pushTitle.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: pushTitle.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}

extension PushSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PushSettingTableViewCell.identifier, for: indexPath)
                as? PushSettingTableViewCell else { return UITableViewCell() }
        cell.configure(data: toggleTitles[indexPath.row])
        cell.selectionStyle = .none
        cell.toggleDelegate = self
        return cell
    }
    
    
}

extension PushSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView()
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        sectionHeader.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return sectionHeader
    }
}

extension PushSettingViewController: toggleAlertDelegate {
    func goToSettingPage() {
        let alertController = UIAlertController(title: "돈워리 알림을 설정하시겠어요?",
                                                message: "설정에서 알림을 허용해주세요",
                                                preferredStyle: .alert)
        
        let goToSettings = UIAlertAction(title: "설정으로가기", style: .default) {_ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL)
            }
        }
        alertController.addAction(goToSettings)
        alertController.addAction(UIAlertAction(title: "취소", style: .default))
        self.present(alertController, animated: true)
    }
    
    func toggleAlertTrue() {
        let notificationAlert = UIAlertController(title: "알람 비활성화",
                                                  message: "알람을 비활성화했습니다",
                                                  preferredStyle: .alert)
        
        notificationAlert.addAction(UIAlertAction(title: "알겠습니다", style: .default))
        self.present(notificationAlert, animated: true)
    }
    
    func toggleAlertFalse() {
        let notificationAlert = UIAlertController(title: "알람 활성화",
                                                  message: "알림을 활성화했습니다",
                                                  preferredStyle: .alert)
        
        notificationAlert.addAction(UIAlertAction(title: "알겠습니다", style: .default))
        self.present(notificationAlert, animated: true)
    }
}
