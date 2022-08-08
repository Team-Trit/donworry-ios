
import Foundation
import UIKit

struct Content {
    let name: String
    let money: Int
}

let contents: [Content] = [
    Content(name: "유쓰햄", money: 6000),
    Content(name: "임애셔", money: 6000),
    Content(name: "김루미", money: 6000),
    Content(name: "정버리", money: 6000)
]

extension UIColor {
    static var PrimaryBlue: UIColor {
        .load(name: "PrimaryBlue")
    }
    
    static var SeperateLine: UIColor {
        .load(name: "SeperateLine")
    }
}

extension UIColor {
    static func load(name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            assert(false, "\(name) 컬러 로드 실패")
            return UIColor()
        }
        return color
    }
}
