//
//  Util.swift
//  Yibby
//
//  Created by Kishy Kumar on 3/12/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import CocoaLumberjack

public class Util {

    static func getAppURLScheme () -> String {
        var infoList: [NSObject : AnyObject] = NSBundle.mainBundle().infoDictionary!
        let urlScheme: NSArray = infoList["CFBundleURLTypes"] as! NSArray
        
        let urlSchemeDict: [NSObject : AnyObject] = urlScheme[0] as! [NSObject : AnyObject]
        
        let urlSchemeStr: String = urlSchemeDict["CFBundleURLName"] as! String
        
        return urlSchemeStr;
    }
}
