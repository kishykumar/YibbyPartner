//
//  UIButtonExtensions.swift
//  Yibby
//
//  Created by Rahul Mehndiratta on 02/04/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit

extension UIButton
{
    func setBorderWithColor()
    {
        self.layer.borderColor = UIColor.borderColor().cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 7
    }
    
    func clearBorderWithColor()
    {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 7
    }
}
