//
//  PaymentCardDecoTableView.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

struct CardDecoItem {
    let title: String
    let content: String
    var isHidden = true
   
    init(title: String,
         content: String,
         isHidden: Bool = true){
        self.title = title
        self.content = content
        self.isHidden = isHidden
    }
    
}

class PaymentCardDecoTableView: UITableView {
    
    private var cardDecoItems: [CardDecoItem] = [
        CardDecoItem(title: "배경 선택", content: "Let’s focus on the cellForRowAt function. After configuring the cell with the title and the description we need to configure the bottomView in order to be hidden when the cell is tapped. We simply set the isHidden property of the bottomView with our value in the array. If you need also to change the icon (up or down) you can set the image based on the isHidden property."),
        CardDecoItem(title: "날짜 선택", content: "날짜 달력있음"),
        CardDecoItem(title: "계좌번호 입력 (선택)", content: "계좌번호 셀"),
        CardDecoItem(title: "파일 추가 (선택)", content: "파일추가 셀"),
    ]
    
    // MARK: - Constructors
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .insetGrouped)
        attributes()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init(coder:) has not been implemented")
    }
    
}

extension PaymentCardDecoTableView {
    
    func attributes() {
        
        self.delegate = self
        self.dataSource = self

        self.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        
        
        // 상단여백제거
        self.tableHeaderView = UIView(frame: CGRect(x: 0.0,
                                                    y: 0.0,
                                                    width: 0.0,
                                                    height: CGFloat.leastNonzeroMagnitude))
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = true
        self.isScrollEnabled = true
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    func layout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension PaymentCardDecoTableView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandableItem = self.cardDecoItems[indexPath.row]
        if expandableItem.isHidden {
            return 48+15
        }else {
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cardDecoItems[indexPath.row].isHidden = !(cardDecoItems[indexPath.row].isHidden)
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
}

extension PaymentCardDecoTableView : UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDecoItems.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestCell
        cell.selectionStyle = .none
        let expandableItem = self.cardDecoItems[indexPath.row]
        
        cell.topTitleLabel.text = expandableItem.title
        cell.bottomDescriptionLabel.text = expandableItem.content
        cell.bottomView.isHidden = expandableItem.isHidden
        
        cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
            
        switch indexPath.row {
            case 0: // 배경선택
                return cell
            case 1: // 날짜선택
                return cell
            case 2: // 계좌번호
                return cell
            case 3: // 파일추가
                return cell
            default:
                return cell
        }

    }

}
