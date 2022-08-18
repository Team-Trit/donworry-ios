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
    @IBOutlet weak var bottomDescriptionLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerStackView.layer.cornerRadius = 10
        self.containerStackView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        print("계좌쪽버튼눌림")
    }
    
}
