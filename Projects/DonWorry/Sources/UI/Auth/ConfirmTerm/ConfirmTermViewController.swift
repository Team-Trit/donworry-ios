//
//  ConfirmTermViewController.swift
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
import RxSwift
import SnapKit

final class ConfirmTermViewController: BaseViewController, View {
    private lazy var confirmTableView: ConfirmTermTableView = {
        let v = ConfirmTermTableView()
        v.dataSource = self
        v.delegate = self
        return v
    }()
    private lazy var confirmButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "완료"
        v.isEnabled = true
        return v
    }()
    private lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    private lazy var dimmedView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.black)
        v.alpha = 0
        return v
    }()
    private let maxDimmedAlpha: CGFloat = 0.6
    private let defaultContainerHeight: CGFloat = 300
    private let dismissibleHeight: CGFloat = 200
    private var currentContainerHeight: CGFloat = 300
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private var confirmButtonBottomConstraint: NSLayoutConstraint?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showDimmedView()
        presentContainer()
    }
    
    func bind(reactor: ConfirmTermViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Helper
extension ConfirmTermViewController {
    private func setUI() {
        containerView.addSubviews(confirmTableView, confirmButton)
        view.addSubviews(dimmedView, containerView)
        confirmTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        confirmButtonBottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        NSLayoutConstraint.activate([
            containerViewHeightConstraint!, containerViewBottomConstraint!, confirmButtonBottomConstraint!
        ])
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - Bind
extension ConfirmTermViewController {
    private func dispatch(to reactor: ConfirmTermViewReactor) {
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: ConfirmTermViewReactor) {
        reactor.pulse(\.$step)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.route(to: $0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension ConfirmTermViewController {
    private func route(to step: ConfirmTermStep) {
        switch step {
        case .home:
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .init("AgreeTerm.dismiss.signup.routeToHome"), object: nil)
            }
        }
    }
}

// MARK: - Custom Modal Helper
extension ConfirmTermViewController {
    private func showDimmedView() {
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    private func presentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.confirmButtonBottomConstraint?.constant = -50
            self.view.layoutIfNeeded()
        }
    }
    private func dismissContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultContainerHeight
            self.confirmButtonBottomConstraint?.constant = self.defaultContainerHeight
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }

    private func animateConfirmButtonHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.confirmButtonBottomConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TableViewDataSource
extension ConfirmTermViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.checkedTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reactor = reactor else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermConfirmCell", for: indexPath)
        cell.textLabel?.text = "* \((reactor.currentState.checkedTerms[indexPath.row]))"
        cell.textLabel?.font = .designSystem(weight: .regular, size: ._15)
        cell.textLabel?.textColor = .designSystem(.gray818181)
        return cell
    }
}

// MARK: - TableViewDelegate
extension ConfirmTermViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ConfirmTermTableViewHeader.identifier)  as? ConfirmTermTableViewHeader else { return UIView() }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

// MARK: - Interaction Functions
extension ConfirmTermViewController {
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newContainerHeight = currentContainerHeight - translation.y
        let newButtonHeight = translation.y - 50

        switch gesture.state {
        case .changed:
            containerViewHeightConstraint?.constant = newContainerHeight
            confirmButtonBottomConstraint?.constant = newButtonHeight
            view.layoutIfNeeded()
        case .ended:
            if newContainerHeight < dismissibleHeight {
                self.dismissContainerView()
            }
            else {
                self.animateContainerHeight(defaultContainerHeight)
                self.animateConfirmButtonHeight(-50)
            }
        default:
            break
        }
    }
}
