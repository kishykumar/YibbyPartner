//
//  YibbyPaddingLabel.swift
//  Yibby
//
//  Created by Kishy Kumar on 10/16/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit

@IBDesignable
open class YibbyPaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    func sharedSetup() {
        
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
    }
    
    /**
     Changes to this parameter draw the border of `self` in the given width.
     */
    @IBInspectable
    var borderWidth: CGFloat = 1.0 {
        didSet {
            if borderWidth >= 0 {
                self.layer.borderWidth = CGFloat(borderWidth)
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter round the corners of `self` in the given corner radius.
     */
    @IBInspectable
    var cornerRadius: CGFloat = 8.0 {
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
    
    override open func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override open var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
