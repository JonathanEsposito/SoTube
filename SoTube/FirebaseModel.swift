//
//  FirebaseModel.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation
import Firebase

class Firebase: DatabaseModel {
    
    func succesfullLogin(withEmail email: String, password: String, delegate: DatabaseDelegate) -> Bool {
        var succesfullLogin = false
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                delegate.showAlert(withTitle: "Login Error", message: error.localizedDescription, actions: nil)
                return
            }
            
            guard let currentUser = user, currentUser.isEmailVerified else {
                
                let actions = [
                    UIAlertAction(title: "Resent email", style: .default, handler: { (action) in
                        user?.sendEmailVerification(completion: nil)
                    }),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ]
                
                delegate.showAlert(withTitle: "Email address not confirmed", message: "You haven't confirmed your email address yet. We sent you a confirmation email upon refistration. You can click the verification link in that email. If you lost that email we'll gladly send you a new confirmation email. In that case you ought to tap Resend confirmation email.", actions: actions)
                return
            }
            
            succesfullLogin = true
        })
        return succesfullLogin
    }
    
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String, delegate: DatabaseDelegate) {
        FIRAuth.auth()?.createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
            if let error = error {
                delegate.showAlert(withTitle: "Registration error", message: error.localizedDescription, actions: nil)
                return
            }
            
            // Add userName
            if let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
                changeRequest.displayName = userName
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            // Send Verification email
            user?.sendEmailVerification(completion: nil)
            
            let dismissDelegateAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    // Dismiss the current view controller
                    delegate.dismiss(animated: true, completion: nil)
            })
            
            delegate.showAlert(withTitle: "Email Verification", message: "We've just sent a confirmation email to \(emailAddress). Please check your inbox and click the verification link in that email to complete registration.", actions:  [dismissDelegateAction])
        })
    }
    
    func resetPassword(forEmail email: String, delegate: DatabaseDelegate) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                delegate.showAlert(withTitle: "Password reset error", message: error.localizedDescription, actions:  nil)
            } else {
                delegate.showAlert(withTitle: "Password reset", message: "An email has been send to \(email). Please click the reset password link in that email to complete the password reset.", actions: nil)
            }
        }
    }
}
