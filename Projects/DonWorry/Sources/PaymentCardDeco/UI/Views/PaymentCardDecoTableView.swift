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
    var isHidden = true
   
    init(title: String, isHidden: Bool = true){
        self.title = title
        self.isHidden = isHidden
    }
    
}

class PaymentCardDecoTableView: UITableView {
    
    private var cardDecoItems: [CardDecoItem] = [
        CardDecoItem(title: "배경 선택"),
        CardDecoItem(title: "날짜 선택"),
        CardDecoItem(title: "계좌번호 입력 (선택)"),
        CardDecoItem(title: "파일 추가 (선택)"),
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

        /* register cell */
        self.register(UINib(nibName: "FilePickerCell", bundle: nil), forCellReuseIdentifier: "FilePickerCell")
        self.register(UINib(nibName: "ColorPickerCell", bundle: nil), forCellReuseIdentifier: "ColorPickerCell")
        self.register(UINib(nibName: "PayDatePickerCell", bundle: nil), forCellReuseIdentifier: "PayDatePickerCell")
        self.register(UINib(nibName: "AccountInputCell", bundle: nil), forCellReuseIdentifier: "AccountInputCell")
        self.register(AttachedPickerCell.self, forCellReuseIdentifier: AttachedPickerCell.cellID)
        
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
            switch indexPath.row {
            case 0: return 180
            case 1: return 400
            case 2: return 200
            case 3: return 200
            default:
                return 300
            }
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
        
        let expandableItem = self.cardDecoItems[indexPath.row]
            
        switch indexPath.row {
            case 0: // 배경선택
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerCell", for: indexPath) as! ColorPickerCell
                cell.bottomView.isHidden = expandableItem.isHidden
                cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
                cell.selectionStyle = .none
                return cell
            
            case 1: // 날짜선택
                let cell = tableView.dequeueReusableCell(withIdentifier: "PayDatePickerCell", for: indexPath) as! PayDatePickerCell
                    cell.selectionStyle = .none
                    cell.bottomView.isHidden = expandableItem.isHidden
                    cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
                return cell
            
            case 2: // 계좌번호
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccountInputCell", for: indexPath) as! AccountInputCell
                cell.bottomView.isHidden = expandableItem.isHidden
                cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
                cell.selectionStyle = .none
                return cell
            
            case 3: // 파일추가
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilePickerCell", for: indexPath) as! FilePickerCell
                cell.bottomView.isHidden = expandableItem.isHidden
                cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
                cell.selectionStyle = .none
                return cell
//                let cell = tableView.dequeueReusableCell(withIdentifier: AttachedPickerCell.cellID, for: indexPath) as! AttachedPickerCell
//                cell.bottomView.isHidden = expandableItem.isHidden
//    //            cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
//                cell.selectionStyle = .none
//                return cell

            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilePickerCell", for: indexPath) as! FilePickerCell
                cell.bottomView.isHidden = expandableItem.isHidden
                cell.chevronImageView.image = UIImage(systemName: expandableItem.isHidden ? "chevron.down" : "chevron.up")
                cell.selectionStyle = .none
                return cell
        }

    }

}
