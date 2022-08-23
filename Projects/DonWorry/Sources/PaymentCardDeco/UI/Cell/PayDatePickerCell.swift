//
//  PayDatePickerCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class PayDatePickerCell: UITableViewCell {

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var payDatePicker: UIDatePicker!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!{
        didSet {
            bottomView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topTitleLabel.textColor = UIColor(hex: "#606060FF")
        self.containerStackView.layer.cornerRadius = 10
        self.containerStackView.layer.masksToBounds = true
        self.payDatePicker.widthAnchor.constraint(equalToConstant: 280).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
