//
//  PayPalModel.swift
//  Paypal SDK test
//
//  Created by VDAB Cursist on 12/05/17.
//  Copyright © 2017 VDAB. All rights reserved.
//

class PayPalModel: NSObject, PayPalPaymentDelegate {
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }

    
    var payPalConfig = PayPalConfiguration()
    
    override init() {
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "NV met Talent"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        payPalConfig.payPalShippingAddressOption = .both
        //Can also be .payPal
        
        //got from developer.paypal.com
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AalTwHLuWdvokmPt_jePK6iLl1EIx_-IapLZPgVuDqH9Wzx38bPCkxJ0hnfR-WQfLl1X-48HUCyMq39N",
                                                               PayPalEnvironmentSandbox: "mcresty-facilitator@hotmail.com"])
        
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
 
    func givePaypalVC(forProduct product: String, amount: Int, withPrice price: Double, inCurrency currency: String, withSku sku: String?) -> UIViewController? {
        
        let item = PayPalItem(name: "\(amount) \(product)", withQuantity: 1, withPrice: NSDecimalNumber(string: String(price)), withCurrency: currency, withSku: sku)
        
        let items = [item]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: currency, shortDescription: "\(amount) \(product)", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            return paymentViewController
        } else {
            print("Payment not processable: \(payment)")
            return nil
            
        }
    }
    
    
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
        })
    }
    
}
