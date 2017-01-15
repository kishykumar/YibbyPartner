//
//  YBLeftImageTextField.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/14/17.
//  Copyright © Yibby MyComp. All rights reserved.
//

import UIKit

@IBDesignable
class YBLeftImageTextField: YBFloatLabelTextField {
    
    let displacement: CGFloat = 20

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    func sharedSetup() {
        self.leftViewMode = .always
        self.leftView = UIImageView(image: UIImage(named: InterfaceImage.Lock.rawValue))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += displacement
        return textRect
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x -= displacement
        return textRect
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        var textRect = super.editingRect(forBounds: bounds)
        textRect.origin.x -= displacement
        return textRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds
    }
    
    /**
     Changes to this parameter draw the border of `self` in the given width.
     */
    @IBInspectable
    var leftImage: UIImage? {
        didSet {
            self.leftView = UIImageView(image: leftImage)
        }
    }
}
