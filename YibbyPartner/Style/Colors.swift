//
//  Colors.swift
//  Yibby
//
//  Created by Kishy Kumar on 7/2/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit

private struct YibbyColors {
    static let grey231F20: UIColor = UIColor(netHex: 0x231F20)
    static let grey3: UIColor = UIColor(netHex: 0x333333)
    static let grey4D: UIColor = UIColor(netHex: 0x4D4D4D)
    static let greenD1: UIColor = UIColor(netHex: 0x00D100)
    static let grey5: UIColor = UIColor(netHex: 0x555555)
    static let grey6: UIColor = UIColor(netHex: 0x666666)
    static let greyA: UIColor = UIColor(netHex: 0xAAAAAA)
    static let greyC: UIColor = UIColor(netHex: 0xCCCCCC)
    static let greyE5: UIColor = UIColor(netHex: 0xE5E5E5)
    static let greyF1: UIColor = UIColor(netHex: 0xF1F1F1)
    static let greyF2: UIColor = UIColor(netHex: 0xF2F2F2)
    static let yellowFFFFCC: UIColor = UIColor(netHex: 0xFFFFCC)
    static let redFFCCCC: UIColor = UIColor(netHex: 0xFFCCCC)
    static let modalBackground: UIColor = UIColor(white: 0x000000, alpha: 0.7)
    
    static let themeColor1: UIColor = UIColor(netHex: 0x006400)
    static let appBackgroundColor1: UIColor = UIColor(netHex: 0xF1F1F1)
    
    static let textFieldTextColor1: UIColor = UIColor.black
    static let textFieldBackgroundColor1: UIColor = UIColor.white
    
    static let appDarkGreen1: UIColor = UIColor(netHex: 0x2ECC71)
    
    static let navyblue1: UIColor = UIColor(netHex: 0x000080)
    
    static let borderColor: UIColor = UIColor(netHex: 0x31A343)

    static let appDarkBlue1: UIColor = UIColor(netHex: 0x4181B5)
}

public extension UIColor {
    // These colors are taken from the web styleguide. Any other variations should be
    // double checked with B&F or normalized to one of these..
    
    // for these colors, just use UIColor.*Color()
    // black - 0x000000
    // white - 0xFFFFFF
    // red - 0xFF0000
    
    // This color is used as the background on all disabled Yibby buttons
    class func grey231F20() -> UIColor { return YibbyColors.grey231F20 }
    
    // common background color
    class func grey3() -> UIColor { return YibbyColors.grey3 }
    
    // dark line color
    class func grey5() -> UIColor { return YibbyColors.grey5 }
    
    // often used for text:
    class func greyA() -> UIColor { return YibbyColors.greyA }
    
    // often used for disabled text:
    class func greyC() -> UIColor { return YibbyColors.greyC }
    
    // background color for text fields
    class func greyE5() -> UIColor { return YibbyColors.greyE5 }
    
    // Used to color @ mention in omnibar/posts
    class func yellowFFFFCC() -> UIColor { return YibbyColors.yellowFFFFCC }
    
    // Used to color @@ direct mention in omnibar/posts (not implemented yet)
    class func redFFCCCC() -> UIColor { return YibbyColors.redFFCCCC }
    
    // not popular
    class func grey6() -> UIColor { return YibbyColors.grey6 }
    class func greyF1() -> UIColor { return YibbyColors.greyF1 }
    class func greyF2() -> UIColor { return YibbyColors.greyF2 }
    class func grey4D() -> UIColor { return YibbyColors.grey4D }
    
    // get started button background
    class func greenD1() -> UIColor { return YibbyColors.greenD1 }
    
    // explains itself
    class func modalBackground() -> UIColor { return YibbyColors.modalBackground }
    
    class func themeColor1() -> UIColor { return YibbyColors.themeColor1 }
    
    class func appBackgroundColor1() -> UIColor { return YibbyColors.appBackgroundColor1 }
    
    class func textFieldTextColor1() -> UIColor { return YibbyColors.textFieldTextColor1 }
    class func textFieldBackgroundColor1() -> UIColor { return YibbyColors.textFieldBackgroundColor1 }
    
    class func appDarkGreen1() -> UIColor { return YibbyColors.appDarkGreen1 }

    class func navyblue1() -> UIColor { return YibbyColors.navyblue1 }
    
    class func borderColor() -> UIColor { return YibbyColors.borderColor }

    class func appDarkBlue1() -> UIColor { return YibbyColors.appDarkBlue1 }
}
