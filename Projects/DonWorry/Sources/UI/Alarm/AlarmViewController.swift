//
//  AlarmViewController.swift
//  App
//
//  Created by Woody on 2022/09/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions

final class AlarmViewController: BaseViewController, View {
    typealias Reactor = AlarmReactor
    lazy var navigationBar = DWNavigationBar(title: "알림", rightButtonTitle: "전체삭제")

    lazy var emptyStackView: UIStackView = {
        let v = UIStackView()
        v.spacing = 0
        v.alignment = .center
        v.distribution = .fill
        v.axis = .vertical
        return v
    }()

    lazy var emptyImageView: UIImageView = {
        let v = UIImageView(image: UIImage(.ic_spash_logo))
        return v
    }()
    lazy var emptyLabel: UILabel = {
        let v = UILabel()
        v.text = "아직 알림이 없어요."
        v.font = .designSystem(weight: .bold, size: ._15)
        v.textColor = .designSystem(.gray818181)
        return v
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        layout()
    }
    func bind(reactor: Reactor) {
        navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        navigationBar.rightItem!.rx.tap.map { .didTapAlarmClearButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.alarmModels }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alarms in
                self?.emptyStackView.isHidden = !alarms.isEmpty
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
    }

}

// MARK: Routing

extension AlarmViewController {
    func move(to step: AlarmStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .sendDetail:
            break
        }
    }
}

// MARK: setUI

extension AlarmViewController {

    private func attribute() {}
    private func layout() {
        view.addSubview(tableView)
        view.addSubviews(navigationBar, tableView)
        view.addSubview(emptyStackView)
        emptyStackView.addArrangedSubviews(emptyImageView, emptyLabel)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        emptyStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        emptyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }

        tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        navigationBar.rightItem?.addTarget(self, action: #selector(removeAll), for: .touchUpInside)
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25).isActive = true
    }

    @objc private func removeAll() {
        print("모든 알람을 지웁니다")
    }
}

// MARK: UITableView

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.alarmModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.alarmModels[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let alarmModels = reactor?.currentState.alarmModels else { return .init() }
        let cell = tableView.dequeueReusableCell(AlarmTableViewCell.self, for: indexPath)
        cell.cellViewModel = alarmModels[indexPath.section].1[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let alarmModels = reactor?.currentState.alarmModels else { return .init() }
        return alarmModels[section].0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
