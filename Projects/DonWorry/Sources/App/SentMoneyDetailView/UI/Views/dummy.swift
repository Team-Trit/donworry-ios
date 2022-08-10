
import Foundation

struct Payment {
    let name: String
    let date: String
    let totalAmount: Int
    let totalUers: Int
    let myAmount: Int
}

let payments = [
    Payment(name: "우디네 당구장", date: "05/25", totalAmount: 184000, totalUers: 4, myAmount: 44000),
    Payment(name: "유쓰네 삼겹살", date: "05/25", totalAmount: 152000, totalUers: 2, myAmount: 76000)
]

let numberformatter = NumberFormatter()


