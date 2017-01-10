//
//  YibbyButton1.swift
//  Yibby
//
//  Created by Kishy Kumar on 9/5/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import BButton

open class YibbyButton1: BButton {
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    func sharedSetup() {
        self.setType(BButtonType.default)
        buttonCornerRadius = 10.0
    }
}
