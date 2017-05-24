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
        return String(Int(Double(date.timeIntervalSinceReferenceDate) * 1_000_000))
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
    
    init(amount: Int, price: Double, databaseTime: Int) {
        let timeInterval = TimeInterval(databaseTime / 1_000_000)
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        self.init(amount: amount, price: price, date: date)
    }
}
