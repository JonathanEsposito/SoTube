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

    func login(withEmail email: String, password: String, delegate: DatabaseDelegate, onCompletion completionHandler:  (() -> ())? ) {
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
            
            // On completion
            if let completionHandler = completionHandler {
                completionHandler()
            }
        })
    }
    
    func signOut() throws {
        try FIRAuth.auth()?.signOut()
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
        
            /****
             * Add user to database
             ****/
            // Setting the users reference
            let usersReference = FIRDatabase.database().reference(withPath: "users")
            
            // Create User in database
            if let currentUser = user {
                let currentUserReference = usersReference.child(currentUser.uid)
                let propertiesChild = currentUserReference.child("properties")
                let userNameChild = propertiesChild.child("username")
                userNameChild.setValue(userName)
                
                let coinsChild = propertiesChild.child("coins")
                coinsChild.setValue(200)
            }
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
    
    func checkForSongs(onCompletion completionHandler: @escaping (Bool) -> () ) {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            print("user not loged in")
            completionHandler(false)
            return
        }
        
        let userReference = FIRDatabase.database().reference(withPath: "users")
        userReference.child(userID).child("songs").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
            
            if let value = snapshot.value as? NSDictionary {
                print(value)
                let songCount = value.count
                
                if songCount > 0 {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
            } else {
                completionHandler(false)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCurrentUserProfile(onCompletion completionHandler: (Profile) -> ()) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            print("User not logged in")
            return
        }
        let userEmail = currentUser.email ?? ""
        let userUsername = currentUser.displayName ?? ""
        
        let userProfile = Profile(username: userUsername, email: userEmail)
        
        completionHandler(userProfile)
    }
    
    func changeUsername(to newUsername: String, onCompletion completionHandler: @escaping (Error?) -> ()) {
        if let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
            changeRequest.displayName = newUsername
            changeRequest.commitChanges(completion: completionHandler)
        }
    }
    
    func change(_ currentPassword: String, with newPassword: String, for email: String, on delegate: userInfoDelegate, onCompletion completionHandler: @escaping (Error?) -> ()) {
        // reauthenticate
        let user = FIRAuth.auth()?.currentUser
        
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: currentPassword)
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                completionHandler(error)
            } else {
                user?.updatePassword(newPassword, completion: completionHandler)
            }
        }
    }
}
