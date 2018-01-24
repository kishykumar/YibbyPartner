//
//  UIViewExtensions.swift
//  Yibby
//
//  Created by Kishy Kumar on 10/16/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

extension UIView {
    
    func addBottomBorder() {
        let border = CALayer()
        let borderWidth: CGFloat = 1.0
        
        border.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - borderWidth,
                              width: self.frame.size.width,
                              height: borderWidth)
        
        self.layer.addSublayer(border)
    }
    
    func addTopAndBottomBorder() {
        let border = CALayer()
        let borderWidth: CGFloat = 1.0
        
        border.backgroundColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - borderWidth,
                              width: self.frame.size.width,
                              height: borderWidth)
        
        self.layer.addSublayer(border)
        
        let topBorder = CALayer()
        
        topBorder.backgroundColor = UIColor.red.cgColor
        topBorder.frame = CGRect(x: 0,
                              y: 0,
                              width: self.frame.size.width,
                              height: borderWidth)
        
        self.layer.addSublayer(topBorder)
    }
    
    func setRoundedWithWhiteBorder() {
        setRoundedWithBorder(UIColor.white)
    }

    func setRoundedWithBorder(_ color: UIColor) {
        makeRounded()
        setBorder(color)
    }

    func setBorder(_ borderColor: UIColor) {
        let layer = self.layer
        layer.borderWidth = 2.0
        layer.borderColor = borderColor.cgColor
    }
    
    func addShadow() {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        
        // To avoid performance hit, As per: https://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //self.layer.shouldRasterize = true
        //self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadowToRoundView(_ cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        
        // To avoid performance hit, As per: https://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        //self.layer.shouldRasterize = true
        //self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func makeRounded() {
        let layer = self.layer
        self.clipsToBounds = true
        layer.cornerRadius = self.frame.size.height / 2;
        layer.masksToBounds = true
    }
    
    func curvedViewWithBorder(_ cornerRadius: CGFloat, borderColor: UIColor) {
        let layer = self.layer
        self.clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        setBorder(borderColor)
    }
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }

}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}
