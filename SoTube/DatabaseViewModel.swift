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
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String, delegate: DatabaseDelegate)
    func resetPassword(forEmail email: String, delegate: DatabaseDelegate)
    func checkForSongs(onCompetion: @escaping (Bool) -> ())
}

protocol DatabaseDelegate {
    func showAlert(withTitle title: String, message: String, actions: [UIAlertAction]?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class DatabaseViewModel {
    var databaseModel: DatabaseModel = Firebase()
    var delegate: DatabaseDelegate?
    
    func checkUserHasSongs(onCompetion completionHandler: @escaping (Bool) -> () ) {
        databaseModel.checkForSongs(onCompetion: completionHandler)
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
}
