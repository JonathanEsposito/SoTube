//
//  PayPalViewModel.swift
//  Paypal SDK test
//
//  Created by VDAB Cursist on 15/05/17.
//  Copyright © 2017 VDAB. All rights reserved.
//

import Foundation

class PaymentViewModel {
    let paymentModel = PayPalModel()
    
    enum Currency {
        case euro, uSDollar
        
        var code: String {
            switch self {
            case .euro: return "EUR"
            case .uSDollar: return "USD"
            }
        }
        
    }
    
    let pricePerAmount = [100: 4.99, 200: 9.49, 500: 21.99, 1000: 39.99]
    
    
    func giveTransactionVC(forProduct product: String, amount: Int, inCurrency currency: Currency, withSku sku: String?) -> UIViewController? {
        return paymentModel.givePaypalVC(forProduct: product, amount: amount, withPrice: pricePerAmount[amount]!, inCurrency: currency.code, withSku: sku)
    }
    
    func paymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentModel.payPalPaymentDidCancel(paymentViewController)
    }
    
    func paymentDidComplete(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentModel.payPalPaymentViewController(paymentViewController, didComplete: completedPayment)
        
        
    }
}
