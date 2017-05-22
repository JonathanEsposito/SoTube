//
//  ChangePasswordViewController.swift
//  SoTube
//
//  Created by .jsber on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var currentUsernameTextField: UITextField!
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let transitioner = CAVTransitioner()
    var username: String?
    var database: DatabaseViewModel?
    var delegate: usernameDelegate?
    
    // MARK: - Initialization
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsView?.addBorder(side: .top, thickness: 1, color: UIColor.groupTableViewBackground)
        cancelButton.addBorder(side: .right, thickness: 1, color: UIColor.groupTableViewBackground)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK: - IBActions
    @IBAction func doDismiss(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        
        
        
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
}
