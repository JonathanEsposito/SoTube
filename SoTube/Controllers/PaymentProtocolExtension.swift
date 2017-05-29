//
//  PaymentViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit


protocol PaymentDelegate {
    var paymentViewModel: PaymentViewModel {get}
}

extension PaymentDelegate where Self: UIViewController {

    func buySoCoin(amount: Int, onCompletion completionHandler: @escaping (Int)->()) {
        
        let paymentVC = paymentViewModel.giveTransactionVC(forProduct: "SoCoins", amount: amount, inCurrency: .euro, withSku: nil, onCompletion: completionHandler)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let payWithPayPal = UIAlertAction(title: "PayPal", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            self.present(paymentVC!, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel/*.default*/, handler: {(alert :UIAlertAction!) in
            print("Cancel button tapped")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(payWithPayPal)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentTopUpAlertController(onCompletion completionHandler: @escaping (Int)->()) {
        let alertController = UIAlertController(title: "Topup your account", message: "Choose the amount you want:", preferredStyle: .actionSheet)
        
        // Sort pricePerAmount dictionary
        let pricePerAmount = paymentViewModel.pricePerAmount
        let buyAmounts = pricePerAmount.keys.sorted(by: <)
        
        let alertActions = buyAmounts.map { UIAlertAction(title: "\($0) at \(pricePerAmount[$0]!)€", style: .default, handler: { (alertAction) in
            let alertTitle = alertAction.title
            let titleComponents = alertTitle?.components(separatedBy: " at ")
            if let amountString = titleComponents?.first, let amount = Int(amountString) {
                self.buySoCoin(amount: amount, onCompletion: completionHandler)
            }
        }) }
        alertActions.forEach { alertController.addAction($0) }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
