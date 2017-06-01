//
//  CoinPurchase.swift
//  SoTube
//
//  Created by .jsber on 24/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation

struct CoinPurchase {
    let amount: Int
    let price: Double
    let date: Date
    
    var dateString: String {
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }
    
    var keyDate: String {
        // Best way to remove comma without UIInt32 overflow (iPhone 5)
        let dateString = String(date.timeIntervalSinceReferenceDate)
        var dateWithoutComma = dateString.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        while dateWithoutComma.characters.count < 15 {
            dateWithoutComma.insert("0", at: dateWithoutComma.endIndex)
        }
        return dateWithoutComma
    }
    
    var dictionary: [String : [String : Double]] {
        return [ keyDate : [
            String(amount) : price
            ]]
    }
    
    init(amount: Int, price: Double, date: Date) {
        self.amount = amount
        self.price = price
        self.date = date
    }
    
    init(amount: Int, price: Double) {
        self.init(amount: amount, price: price, date: Date())
    }
    
    init(amount: Int, price: Double, databaseTime: TimeInterval) {
        let date = Date(timeIntervalSinceReferenceDate: databaseTime)
        self.init(amount: amount, price: price, date: date)
    }
}
