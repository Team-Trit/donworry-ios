//
//  PayDatePickerCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

protocol PayDatePickerCellDelegate: AnyObject {
    func updatePayDate(with date : Date)
}

class PayDatePickerCell: UITableViewCell {

    weak var payDatePickerCellDelegate: PayDatePickerCellDelegate?
    
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
        self.payDatePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.payDatePicker.date = Date() //default : TODAY
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(isHidden: Bool) {
        self.bottomView.isHidden = isHidden
        self.chevronImageView.image = UIImage(systemName: isHidden ? "chevron.down" : "chevron.up")
        self.selectionStyle = .none
    }
}

extension PayDatePickerCell {
      @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
          payDatePickerCellDelegate?.updatePayDate(with: datePicker.date)
      }
}
