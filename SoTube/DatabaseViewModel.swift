//
//  DatabaseViewModel.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation

protocol DatabaseModel {
    func login(withEmail email: String, password: String, delegate: DatabaseDelegate, onCompletion: (() -> ())?)
    func signOut() throws
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String, delegate: DatabaseDelegate)
    func resetPassword(forEmail email: String, delegate: DatabaseDelegate)
    func checkForSongs(onCompletion: @escaping (Bool) -> ())
    func getCurrentUserProfile(onCompletion: (Profile) -> ())
    func changeUsername(to: String, onCompletion: @escaping (Error?) -> ())
    func change(_ currentPassword: String, with newPassword: String, for email: String, on delegate: userInfoDelegate, onCompletion completionHandler: @escaping (Error?) -> ())
//    func reauthenticate(withPassword: String, email: String, onCompletion: (Error?) -> ())
}

protocol DatabaseDelegate {
    func showAlert(withTitle title: String, message: String, actions: [UIAlertAction]?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class DatabaseViewModel {
    var databaseModel: DatabaseModel = Firebase()
    var delegate: DatabaseDelegate?
    
    func checkUserHasSongs(onCompletion completionHandler: @escaping (Bool) -> () ) {
        databaseModel.checkForSongs(onCompletion: completionHandler)
    }
    
    func login(withEmail email: String, password: String, onCompletion completionHandler: (() -> ())? ) {
        guard let delegate = delegate else {
            fatalError("DatabaseDelegate not yet set!")
        }
        
        databaseModel.login(withEmail: email, password: password, delegate: delegate, onCompletion: completionHandler)
    }
    
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String) {
        guard let delegate = delegate else {
            fatalError("DatabaseDelegate not yet set!")
        }
        databaseModel.createNewAccount(withUserName: userName, emailAddress: emailAddress, password: password, delegate: delegate)
    }
    
    func resetPassword(forEmail email: String) {
        guard let delegate = delegate else {
            fatalError("DatabaseDelegate not yet set!")
        }
        databaseModel.resetPassword(forEmail: email, delegate: delegate)
    }
    
    func getCurrentUserProfile(onCompletion completionHandler: (Profile) -> ()) {
        databaseModel.getCurrentUserProfile(onCompletion: completionHandler)
    }
    
    func changeUsername(to newUsername: String, onCompletion completionHandler: @escaping (Error?) -> ()) {
        databaseModel.changeUsername(to: newUsername, onCompletion: completionHandler)
    }
    
    func change(_ currentPassword: String, with newPassword: String, for email: String, on delegate: userInfoDelegate, onCompletion completionHandler: @escaping (Error?) -> ()) {
        databaseModel.change(currentPassword, with: newPassword, for: email, on: delegate, onCompletion: completionHandler)
    }
    
    func signOut(onCompletion completionHandler: () -> ()) {
        do {
            try databaseModel.signOut()
        } catch {
            delegate?.showAlert(withTitle: "Problem signing off", message: error.localizedDescription, actions: nil)
            return
        }
        completionHandler()
    }
}
