//
//  Util.swift
//  Yibby
//
//  Created by Kishy Kumar on 3/12/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD
import CocoaLumberjack

open class Util {

    static func getAppURLScheme () -> String {
        var infoList: [AnyHashable: Any] = Bundle.main.infoDictionary!
        let urlScheme: NSArray = infoList["CFBundleURLTypes"] as! NSArray
        
        let urlSchemeDict: [AnyHashable: Any] = urlScheme[0] as! [AnyHashable: Any]
        
        let urlSchemeStr: String = urlSchemeDict["CFBundleURLName"] as! String
        
        return urlSchemeStr;
    }
}
