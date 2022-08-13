//
//  CardColorPickerCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class CardColorPickerCell: UITableViewCell {
    
    let name = UILabel()
    let descriptionLabel = UILabel()
    
    static let identifier = "CardColorPickerCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//
//    static func nib() -> UINib {
//        return UINib(nibName: "CardColorPickerCell", bundle: nil)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layout() {
        self.addSubviews(name, descriptionLabel)
        self.backgroundColor  = .designSystem(.white)
        self.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        name.text = "여기확인"
        name.backgroundColor = .yellow
        descriptionLabel.text = "설명어쩌니"
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 200),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            name.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            descriptionLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
        ])
        
        
        
    }
    

}
