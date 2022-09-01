//
//  AgreeTermViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/17.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import SnapKit

final class AgreeTermViewController: BaseViewController, View, Stepper {
    typealias Reactor = AgreeTermViewReactor
    let steps = PublishRelay<Step>()
    private lazy var navigationBar = DWNavigationBar(title: "돈워리 이용약관")
    private lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "돈워리 이용을 위해\n약관에 동의해 주세요."
        v.font = .designSystem(weight: .bold, size: ._18)
        v.numberOfLines = 0
        return v
    }()
    private lazy var agreeTermTableView: AgreeTermTableView = {
        let v = AgreeTermTableView()
        v.dataSource = self
        v.delegate = self
        return v
    }()
    private lazy var doneButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "완료"
        v.isEnabled = false
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    func bind() {
        navigationBar.leftItem.rx.tap
            .bind { self.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension AgreeTermViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, descriptionLabel, agreeTermTableView, doneButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        agreeTermTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-170)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(297)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Bind
extension AgreeTermViewController {
    private func dispatch(to reactor: Reactor) {
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.backButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.doneButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.isChecked[1...3].allSatisfy { $0 } }
            .asDriver(onErrorJustReturn: false)
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: DonworryStep.none)
            .compactMap { $0 }
            .drive { [weak self] in
                self?.route(to: $0)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension AgreeTermViewController {
    private func route(to step: DonworryStep) {
        switch step {
        case .popViewController:
            self.steps.accept(DonworryStep.popViewController)
            
        case let .confirmTermIsRequired(checkedTerms, newUser):
            self.steps.accept(DonworryStep.confirmTermIsRequired(checkedTerms: checkedTerms, newUser: newUser))
            
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension AgreeTermViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (reactor?.dataSource.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgreeTermTableViewCell.identifier, for: indexPath) as? AgreeTermTableViewCell else { return UITableViewCell() }
        let index = indexPath.row
        cell.titleLabel.text = reactor?.dataSource[index]
        
        cell.checkButton.rx.tap
            .map { Reactor.Action.checkButtonPressed(index) }
            .bind(to: reactor!.action)
            .disposed(by: cell.disposeBag)
        
        reactor?.state.map { $0.isChecked[index] }
            .asDriver(onErrorJustReturn: false)
            .drive {
                    cell.checkButton.setImage(UIImage(systemName: $0 ? "checkmark.circle.fill" : "circle"), for: .normal)
                    cell.checkButton.tintColor = .designSystem($0 ? .mainBlue : .grayC5C5C5)
            }
            .disposed(by: cell.disposeBag)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AgreeTermViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AgreeTermTableViewCell else { return }
        cell.disposeBag = DisposeBag()
    }
}
