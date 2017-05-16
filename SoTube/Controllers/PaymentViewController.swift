//
//  PaymentViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit


protocol paymentDelegate {
    var paymentViewModel: PaymentViewModel {get}
}


class PaymentViewController: UIViewController, paymentDelegate {
    
    let paymentViewModel = PaymentViewModel()

    @IBAction func buySoCoin(_ sender: UIButton) {
        buySoCoin(amount: Int(sender.title(for: .normal)!)!)
    }
}

extension paymentDelegate where Self: UIViewController {

    func buySoCoin(amount: Int) {
        
        let paymentVC = paymentViewModel.giveTransactionVC(forProduct: "SoCoins", amount: amount, inCurrency: .euro, withSku: nil)
        
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
}
