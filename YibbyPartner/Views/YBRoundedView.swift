//
//  YBRoundedView.swift
//  Yibby
//
//  Created by Kishy Kumar on 2/11/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

//
//  SwiftyAvatar.swift
//  SwiftyAvatar
//
//  Created by Dimitrios Kalaitzidis on 04/08/16.
//  Copyright © 2016 Dimitrios Kalaitzidis. All rights reserved.
//

import UIKit

@IBDesignable public class YBRoundedView: UIView {
    
    init(size:CGFloat = 200, roundess:CGFloat = 2, borderWidth:CGFloat = 2, borderColor:UIColor = UIColor.white, background:UIColor = UIColor.clear){
        self.roundness = roundess
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.background = background
        
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var roundness: CGFloat = 2 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var background: UIColor = UIColor.clear {
        didSet{
            setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / roundness
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = background.cgColor
        clipsToBounds = true
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: bounds.width / roundness)
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        layer.mask = mask
    }
}

