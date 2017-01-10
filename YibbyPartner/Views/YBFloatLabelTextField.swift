//
//  YBFloatLabelTextField.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/10/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit

@IBDesignable
class YBFloatLabelTextField: FloatLabelTextField {
    /**
     Changes to this parameter draw the border of `self` in the given width.
     */
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            if borderWidth >= 0 {
                self.borderStyle = .none
                self.layer.borderWidth = CGFloat(borderWidth)
            } else {
                self.borderStyle = .roundedRect
                self.layer.borderWidth = 0
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter round the corners of `self` in the given corner radius.
     */
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius >= 0 {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter change the color of the border of `self`.
     */
    @IBInspectable
    var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
}
