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

protocol PaymentCardDecoTableViewDelegate: AnyObject {
    func updateTableViewHeight(to height: CGFloat)
    func updateCardColor(with color: CardColor)
    func updatePayDate(with date : Date)
    func showPhotoPicker()
    func updateHolder(holder: String)
    func updateAccountNumber(number: String)
}

protocol PhotoUpdateDelegate: AnyObject {
    func updatePhotoCell(img: [UIImage])
}

class PaymentCardDecoTableView: UITableView {
    
    private var cardDecoItems: [CardDecoItem] = [
        CardDecoItem(title: "배경 선택"),
        CardDecoItem(title: "날짜 선택"),
        CardDecoItem(title: "계좌번호 입력 (선택)"),
        CardDecoItem(title: "파일 추가 (선택)"),
    ]
    private var selectedIndex: Int = -1

    weak var paymentCardDecoTableViewDelegate: PaymentCardDecoTableViewDelegate?
    weak var photoUpdateDelegate: PhotoUpdateDelegate?

    var selectedColor: CardColor?
    var filePickerCellViewModel: FilePickerCellViewModel?

    // MARK: - Constructors
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .insetGrouped)
        attributes()
        layout()
    }
    
    override var intrinsicContentSize: CGSize {
        let number = numberOfRows(inSection: 0)
        var height: CGFloat = 0

        for i in 0..<number {
            guard let cell = cellForRow(at: IndexPath(row: i, section: 0)) else {
                continue
            }
            height += cell.bounds.height
        }
        return CGSize(width: contentSize.width, height: height)
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
    
    func updatePhotoCell(img : [UIImage]) {
        photoUpdateDelegate?.updatePhotoCell(img: img)
    }
    
}


/* Cell Delegate 구현 */
extension PaymentCardDecoTableView: FilePickerCellCollectionViewDelegate, ColorPickerCellDelegate, PayDatePickerCellDelegate {
    
    // ColorPickerCellDelegate
    func updateCardColor(with color : CardColor) {
        paymentCardDecoTableViewDelegate?.updateCardColor(with: color)
    }
    
    // PayDatePickerCellDelegate
    func updatePayDate(with date : Date) {
        paymentCardDecoTableViewDelegate?.updatePayDate(with: date)
    }
    
    // FilePickerCellCollectionViewDelegate
    func selectPhoto(){
        paymentCardDecoTableViewDelegate?.showPhotoPicker()
    }
    
}

extension PaymentCardDecoTableView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandableItem = self.cardDecoItems[indexPath.row]
        if expandableItem.isHidden {
            return 48 + 15
        } else {
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
        
        let cellHeight: CGFloat = 48
        let cellSpacing: CGFloat = 15
        let cellHeightArea: CGFloat = cellHeight + cellSpacing
        
        var height: CGFloat = cellHeightArea * 4 + 5

        if selectedIndex == indexPath.row {
            if selectedIndex > -1 {
                cardDecoItems[selectedIndex].isHidden = !(cardDecoItems[selectedIndex].isHidden)
                selectedIndex = -1
            }
            
        } else {
            if selectedIndex > -1 {
                cardDecoItems[selectedIndex].isHidden = !(cardDecoItems[selectedIndex].isHidden)
            }

            selectedIndex = indexPath.row
            cardDecoItems[selectedIndex].isHidden = !(cardDecoItems[selectedIndex].isHidden)
        }

        switch selectedIndex {
        case 0: height += 180 - cellHeightArea
        case 1: height += 400 - cellHeightArea
        case 2: height += 200 - cellHeightArea
        case 3: height += 200 - cellHeightArea
        default: break
        }
        paymentCardDecoTableViewDelegate?.updateTableViewHeight(to: height)
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
            cell.configure(isHidden: expandableItem.isHidden)
            cell.colorPickerCellDelegate = self
            cell.selectedColor = selectedColor
            return cell
            
        case 1: // 날짜선택
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayDatePickerCell", for: indexPath) as! PayDatePickerCell
            cell.configure(isHidden: expandableItem.isHidden)
            cell.payDatePickerCellDelegate = self
            return cell
            
        case 2: // 계좌번호
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountInputCell", for: indexPath) as! AccountInputCell
            cell.configure(isHidden: expandableItem.isHidden)

            cell.accountInputField.holderTextField.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .subscribe(onNext: { text in
                    self.paymentCardDecoTableViewDelegate?.updateHolder(holder: text)
                })
                .disposed(by: cell.disposeBag)
            
            cell.accountInputField.accountTextField.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .subscribe(onNext: { text in
                    self.paymentCardDecoTableViewDelegate?
                        .updateAccountNumber(number: text)
                })
                .disposed(by: cell.disposeBag)

            
            return cell
            
        case 3: // 파일추가
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilePickerCell", for: indexPath) as! FilePickerCell
            cell.configure(isHidden: expandableItem.isHidden)
            cell.filePickerCellCollectionViewDelegate = self
            print("리로드해요 : ", filePickerCellViewModel)
            cell.viewModel = filePickerCellViewModel
            return cell
        default:
            return UITableViewCell()
        }

    }

}
