//
//  DatabaseViewModel.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation

protocol DatabaseModel {
    func succesfullLogin(withEmail email: String, password: String, delegate: DatabaseDelegate) -> Bool
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String, delegate: DatabaseDelegate)
    func resetPassword(forEmail email: String, delegate: DatabaseDelegate)
}

protocol DatabaseDelegate {
    func showAlert(withTitle title: String, message: String, actions: [UIAlertAction]?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class DatabaseViewModel {
    var databaseModel: DatabaseModel = Firebase()
    var delegate: DatabaseDelegate?
    
    func succesfullLogin(withEmail email: String, password: String) -> Bool {
        guard let delegate = delegate else {
            fatalError("DatabaseDelegate not yet set!")
        }
        
        if databaseModel.succesfullLogin(withEmail: email, password: password, delegate: delegate) {
            return true
        }
        return false
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
}
