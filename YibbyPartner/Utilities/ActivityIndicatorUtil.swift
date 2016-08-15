//
//  ActivityIndicatorUtil.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/8/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import SVProgressHUD
import CocoaLumberjack

public class ActivityIndicatorUtil {
    
    static func enableActivityIndicator (view: UIView) {
        ActivityIndicatorUtil.enableActivityIndicator(view, status: nil, mask: SVProgressHUDMaskType.Black,
                                                      maskColor: nil, style: SVProgressHUDStyle.Dark)
    }
    
    static func enableActivityIndicator (view: UIView, status: String?,
                                         mask: SVProgressHUDMaskType?, maskColor: UIColor?,
                                         style: SVProgressHUDStyle?) {
        
        if let mask = mask {
            SVProgressHUD.setDefaultMaskType(mask)
        }
        
        if let maskColor = maskColor {
            SVProgressHUD.setBackgroundLayerColor(maskColor)
        }
        
        if let style = style {
            SVProgressHUD.setDefaultStyle(style)
        }
        
        if let status = status {
            SVProgressHUD.showWithStatus(status);
        } else {
            SVProgressHUD.show()
        }
    }
    
    static func disableActivityIndicator (view: UIView) {
        SVProgressHUD.dismiss();
    }
}