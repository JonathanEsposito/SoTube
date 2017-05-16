//
//  ChangePasswordViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!


    @IBAction func savePasswordButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
