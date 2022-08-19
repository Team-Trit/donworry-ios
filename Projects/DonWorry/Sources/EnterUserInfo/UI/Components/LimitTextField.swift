//
//  LimitTextField.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class LimitTextField: UIView {
    private lazy var textField: UITextField = {
        let v = UITextField()
        v.clearButtonMode = .whileEditing
        return v
    }()
    private lazy var line: UILabel = {
        let v = UILabel()
        v.backgroundColor = textField.text!.isEmpty ? .designSystem(.grayC5C5C5) : .designSystem(.mainBlue)
        return v
    }()
    private var limit: Int?
    private var limitLabel: UILabel?
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    convenience init(placeholder: String) {
        self.init()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: UIFont.designSystem(weight: .regular, size: ._13)])

        if reactor == nil {
            reactor = LimitTextFieldReactor()
        }
    }
    
    convenience init(placeholder: String, limit: Int) {
        self.init(placeholder: placeholder)
        self.limit = limit
        setLimitLabel()
        setLimitLabelLayout()
        reactor = LimitTextFieldReactor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension LimitTextField {
    private func setLimitLabel() {
        guard let limit = limit else { return }
        limitLabel = UILabel()
        limitLabel!.text = "0/\(limit)"
        limitLabel!.textColor = .designSystem(.grayC5C5C5)
        limitLabel!.font = .designSystem(weight: .regular, size: ._9)
    }
    
    private func setUI() {
        addSubviews(textField, line)
        if limit != nil {
            addSubview(limitLabel!)
        }
        
        textField.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setLimitLabelLayout() {
        addSubview(limitLabel!)
        limitLabel!.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
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
        
        if limit != nil {
            textObservable.map { $0.count }
                .distinctUntilChanged()
                .map { "\($0)/\(self.limit!)" }
                .bind(to: limitLabel!.rx.text)
                .disposed(by: disposeBag)
        }
        
        textObservable.map { $0.isEmpty }.distinctUntilChanged()
            .map { return UIColor.designSystem($0 ? .grayC5C5C5 : .mainBlue) }
            .bind(to: line.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
