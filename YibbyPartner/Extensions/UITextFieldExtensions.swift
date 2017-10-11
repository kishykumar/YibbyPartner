//
//  UITextFieldExtensions.swift
//  Yibby
//
//  Created by Kishy Kumar on 8/13/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setBottomBorder(_ color: UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func removeBottomBorder() {
        
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.0
        self.layer.shadowRadius = 0.0
    }
}
