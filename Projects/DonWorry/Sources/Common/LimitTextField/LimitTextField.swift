//
//  LimitTextField.swift
//  DonWorryTests
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class LimitTextField: UIView {
    private let textField = UITextField()
    private let line = UILabel()
    private let limitLabel = UILabel()
    private var limit: Int?
    var disposeBag = DisposeBag()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        commonInit()
        textField.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(placeholder: String, limit: Int) {
        self.init(placeholder: placeholder)
        self.limit = limit
        setLimitLabel()
        setLimitLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        reactor = LimitTextFieldReactor()
        attributes()
        layout()
    }
}

// MARK: - Configurations
extension LimitTextField {
    private func attributes() {
        setTextField()
        line.backgroundColor = textField.text!.isEmpty ? .designSystem(.gray2) : .designSystem(.mainBlue)
    }
    
    private func layout() {
        setTextFieldLayout()
        setLineLayout()
    }
    
    // MARK: - Attibutes Helper
    private func setTextField() {
        textField.clearButtonMode = .whileEditing
    }
    
    private func setLimitLabel() {
        guard let limit = limit else { return }
        limitLabel.text = "0/\(limit)"
        limitLabel.textColor = .designSystem(.gray2)
        limitLabel.font = .systemFont(ofSize: 10)
    }
    
    // MARK: - Layout Helper
    private func setTextFieldLayout() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setLineLayout() {
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10)
        ])
    }
    
    private func setLimitLabelLayout() {
        addSubview(limitLabel)
        limitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            limitLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            limitLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10)
        ])
    }
}

// MARK: - Bind
extension LimitTextField: View {
    func bind(reactor: LimitTextFieldReactor) {
        textField.rx.text
            .map { Reactor.Action.edit($0, self.limit) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let textObservable = reactor.state.map { $0.trimmedText }.share()
        textObservable
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textObservable.map { $0.count }
            .distinctUntilChanged()
            .map { self.limit != nil ? "\($0)/\(self.limit!)" : "" }
            .bind(to: limitLabel.rx.text)
            .disposed(by: disposeBag)
        
        textObservable.map { $0.isEmpty } .distinctUntilChanged()
            .map { return UIColor.designSystem($0 ? .gray2 : .mainBlue) }
            .bind(to: line.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
