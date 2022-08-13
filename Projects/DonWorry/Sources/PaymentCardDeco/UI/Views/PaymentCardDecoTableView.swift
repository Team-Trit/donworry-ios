//
//  PaymentCardDecoTableView.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

private enum CellType: String {
    case cardColor
    case datePicker
    case accountInfo
    case attachment
}

private struct Section {
    let title: String
    let options: [String]
    var isOpened = false
   
    init(title: String,
         options: [String],
         isOpened: Bool = false){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
    
}

class PaymentCardDecoTableView: UITableView {
    
    // MARK: - Constructors
    let spaceBetweenSections = 15.0
    private var sections = [Section]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .insetGrouped)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init(coder:) has not been implemented")
    }
    
    
    override var contentSize: CGSize {
        didSet {
            if !constraints.isEmpty {
                invalidateIntrinsicContentSize()
            } else {
                sizeToFit()
            }

            if contentSize != oldValue {
                if let delegate = delegate as? ContentFittingTableViewDelegate {
                    delegate.tableViewDidUpdateContentSize(self)
                }
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }
    

}

extension PaymentCardDecoTableView {
    
    func setUI() {
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.register(CardColorPickerCell.self,
                      forCellReuseIdentifier: CardColorPickerCell.identifier)
        self.register(PayDatePickerCell.nib(),
                      forCellReuseIdentifier: PayDatePickerCell.identifier)
        
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.roundCorners(15)
        
        sections = [
            Section(title: "배경 선택", options: [1].compactMap({ return "Cell \($0)"})),
            Section(title: "날짜 선택", options: [2].compactMap({ return "Cell \($0)"})),
            Section(title: "계좌번호 입력 (선택)", options: [3].compactMap({ return "Cell \($0)"})),
            Section(title: "파일 추가 (선택)", options: [4].compactMap({ return "Cell \($0)"})),
        ]
        
        self.delegate = self
        self.dataSource = self
        
        self.separatorStyle = .none
        
        /* header */
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 66))
        header.backgroundColor = .systemBlue
        
        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.text = "정산카드 꾸미기"
        header.addSubview(headerLabel)
        
        self.tableHeaderView = header
        self.alwaysBounceVertical = false
        self.isScrollEnabled = false
        
    }
    
}

extension PaymentCardDecoTableView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened // toggle
            tableView.reloadSections([indexPath.section], with: .none)
            print("tapped section  \(indexPath)")
        }
        else {
            print("tapped sub cell \(indexPath)")
        }
        
    }
}

extension PaymentCardDecoTableView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.options.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .designSystem(.white)
        
        let cardColorPickerCell = tableView.dequeueReusableCell(withIdentifier: "CardColorPickerCell", for: indexPath) as! CardColorPickerCell
        
        let payDatePickerCell = tableView.dequeueReusableCell(withIdentifier: "PayDatePickerCell", for: indexPath) as! PayDatePickerCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].title
            return cell
        }
        else {
            
            switch indexPath.section {
            case 0:
                return cardColorPickerCell
            case 1:
                return payDatePickerCell
            case 2:
                cell.textLabel?.text = "계좌"
                return cell
            case 3:
                cell.textLabel?.text = "이미지"
                return cell
            default:
                cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]  //1빼는 이유 : 위에서 section title 때문에 하나 추가해서
                return cell
            }
        }

//        return cell
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(spaceBetweenSections / 2)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(spaceBetweenSections / 2)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
}

protocol ContentFittingTableViewDelegate: UITableViewDelegate {
    func tableViewDidUpdateContentSize(_ tableView: UITableView)
}
