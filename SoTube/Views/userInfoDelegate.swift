//
//  userInfoDelegate.swift
//  SoTube
//
//  Created by .jsber on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

protocol userInfoDelegate {
    var reloadUserInfoActivityIndicatorViewCollection: [UIActivityIndicatorView]! { get }
    func updateTextFields()
    func updateUserDefaults(password: String?, orEmail email: String?)
}
