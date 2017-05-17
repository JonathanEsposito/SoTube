//
//  UIViewLoadingFromXib.swift
//  SoTube
//
//  Created by .jsber on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

protocol UIViewLoading {}
extension UIView: UIViewLoading {}

extension UIViewLoading where Self : UIView {
    static func loadFromNib() -> Self {
        let nibName = "\(Self.self)".characters.split {$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
