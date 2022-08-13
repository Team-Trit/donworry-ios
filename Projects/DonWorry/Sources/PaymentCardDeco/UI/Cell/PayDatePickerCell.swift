//
//  PayDatePickerCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class PayDatePickerCell: UITableViewCell {
    
    static let identifier = "PayDatePickerCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PayDatePickerCell", bundle: nil)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
