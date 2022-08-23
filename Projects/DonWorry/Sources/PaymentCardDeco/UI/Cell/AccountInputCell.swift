//
//  AccountInputCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class AccountInputCell: UITableViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    private lazy var accountStackView = AccountStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerStackView.layer.cornerRadius = 10
        self.containerStackView.layer.masksToBounds = true
        layout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func layout() {
        bottomView.addSubview(accountStackView)
        accountStackView.snp.makeConstraints { make in
              make.top.equalToSuperview().offset(10)
              make.leading.trailing.equalToSuperview()
              make.height.equalTo(200)
        }
    }
    
}
