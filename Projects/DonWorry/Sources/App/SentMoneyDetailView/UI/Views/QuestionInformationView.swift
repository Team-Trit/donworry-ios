//
//  QuestionInformationView.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class QuestionInformationView: UIView {
    
    private let questionContent: UILabel = {
        let questionContent = UILabel()
        questionContent.translatesAutoresizingMaskIntoConstraints = false
        questionContent.text = " 최소 송금 알고리즘에 의하여 \n 산정된 결과로, 각 차수별 정산자가 \n 아닐 수 있습니다."
        questionContent.numberOfLines = 3
        questionContent.textAlignment = .left
        questionContent.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        questionContent.textColor = .white
        
        let attrString = NSMutableAttributedString(string: questionContent.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        questionContent.attributedText = attrString
        return questionContent
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        addSubview(questionContent)
        questionContent.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        questionContent.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
