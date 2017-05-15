//
//  PaymentViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    let paymentViewModel = PaymentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buySoCoin(_ sender: UIButton) {
        let paymentVC = paymentViewModel.giveTransactionVC(forProduct: "TestItems", amount: Int(sender.title(for: .normal)!)!, inCurrency: .euro, withSku: nil)
        present(paymentVC!, animated: true, completion: nil)
    }
    
}
