//
//  YBTextField.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/20/16.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import Foundation

open class YBTextField: UITextField {
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20);
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedSetup()
    }
    
    func sharedSetup() {
        self.backgroundColor = UIColor.textFieldBackgroundColor1()
        self.textColor = UIColor.textFieldTextColor1()
        
        self.font = UIFont.systemFont(ofSize: 14)
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6.0;
        self.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        self.setNeedsDisplay()
    }
    
    func removeFormatting() {
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.textFieldTextColor1()
        
        self.font = UIFont.systemFont(ofSize: 14)
        
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0.0;
        self.layer.borderColor = UIColor.clear.cgColor
        padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20);
        
        self.setNeedsDisplay()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }
    
    fileprivate func rectForBounds(_ bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}

