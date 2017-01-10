//
//  YBPickerTextField.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/9/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit

@IBDesignable
class YBPickerTextField: YBFloatLabelTextField {
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    func sharedSetup() {
        self.rightViewMode = .always
        self.rightView = UIImageView(image: UIImage(named: InterfaceImage.DropdownArrow.rawValue))
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 10
        return textRect
    }
}
