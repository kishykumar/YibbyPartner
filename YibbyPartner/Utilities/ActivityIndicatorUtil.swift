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

open class ActivityIndicatorUtil {
    
    static func enableActivityIndicator (_ view: UIView) {
        ActivityIndicatorUtil.enableActivityIndicator(view, status: nil, mask: SVProgressHUDMaskType.black,
                                                      maskColor: nil, style: SVProgressHUDStyle.dark)
    }
    
    static func enableActivityIndicator (_ view: UIView, status: String?,
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
            SVProgressHUD.show(withStatus: status);
        } else {
            SVProgressHUD.show()
        }
    }
    
    static func disableActivityIndicator (_ view: UIView) {
        SVProgressHUD.dismiss();
    }
}
