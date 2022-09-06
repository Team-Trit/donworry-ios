//
//  AccountInputCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class AccountInputCell: UITableViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    lazy var accountInputField = AccountInputField(frame: .zero, type: .PaymentCardDeco)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topTitleLabel.textColor = UIColor(hex: "#606060FF")
        self.containerStackView.layer.cornerRadius = 10
        self.containerStackView.layer.masksToBounds = true
        layout()
        
        /* 뷰띄우기
        accountInputField.chooseBankButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        
        
        let vc = SelectBankViewController()
        let reactor = SelectBankViewReactor()
        vc.reactor = reactor
        self.navigationController.present(vc)
        
        */
    }

}

extension AccountInputCell {
    
    private func layout() {
        bottomView.addSubview(accountInputField)
        accountInputField.snp.makeConstraints { make in
              make.top.equalToSuperview().offset(10)
              make.leading.trailing.equalToSuperview().inset(15)
              make.height.equalTo(200)
        }
    }
    
    func configure(isHidden: Bool) {
        self.bottomView.isHidden = isHidden
        self.chevronImageView.image = UIImage(systemName: isHidden ? "chevron.down" : "chevron.up")
        self.selectionStyle = .none
    }
    
}
