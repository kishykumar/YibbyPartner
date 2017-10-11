//
//  ActivityIndicatorUtil.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/8/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import MBProgressHUD
import CocoaLumberjack

open class ActivityIndicatorUtil {
    
    static func enableActivityIndicator(_ view: UIView) {
        ActivityIndicatorUtil.enableActivityIndicator(view, mode: MBProgressHUDMode.indeterminate, bgStyle: nil, title: nil)
    }
    
    static func enableActivityIndicator(_ view: UIView,
                                        title: String?) {
        
        ActivityIndicatorUtil.enableActivityIndicator(view, mode: MBProgressHUDMode.indeterminate, bgStyle: nil, title: title)
    }
    
    static func enableBlurActivityIndicator(_ view: UIView,
                                            title: String?) {
        
        ActivityIndicatorUtil.enableActivityIndicator(view, mode: MBProgressHUDMode.indeterminate,
                                                      bgStyle: MBProgressHUDBackgroundStyle.blur, title: title)
    }
    
    static func enableActivityIndicator (_ view: UIView,
                                         mode: MBProgressHUDMode?,
                                         bgStyle: MBProgressHUDBackgroundStyle?,
                                         title: String?) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.contentColor = UIColor.black
        hud.isSquare = true
        
        // Will look best, if we set a minimum size.
        hud.minSize = CGSize(width: 60.0, height: 60.0)
        
        hud.bezelView.layer.cornerRadius = 10.0
        hud.bezelView.color = UIColor.white
        hud.bezelView.layer.borderWidth = 1.0
        hud.bezelView.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.3)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        
        if let bgStyle = bgStyle {
            hud.backgroundView.style = bgStyle
        }
        
        if let mode = mode {
            hud.mode = mode
        }
        
        if let title = title {
            hud.label.text = title
        }
    }
    
    static func enableRegularActivityIndicator (_ view: UIView) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        //hud.contentColor = UIColor.black
        
        // Will look best, if we set a minimum size.
        hud.minSize = CGSize(width: 10.0, height: 10.0)
        
        hud.bezelView.color = UIColor.clear
        hud.bezelView.layer.borderColor = UIColor.clear.cgColor
        
        hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.3)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
    }
    
    
    //    static func enableActivityIndicator (_ view: UIView) {
    //        ActivityIndicatorUtil.enableActivityIndicator(view, status: nil, mask: SVProgressHUDMaskType.black,
    //                                     maskColor: nil, style: SVProgressHUDStyle.dark)
    //    }
    //
    //    static func enableActivityIndicator (_ view: UIView, status: String?,
    //                                         mask: SVProgressHUDMaskType?, maskColor: UIColor?,
    //                                         style: SVProgressHUDStyle?) {
    //
    //        if let mask = mask {
    //            SVProgressHUD.setDefaultMaskType(mask)
    //        }
    //
    //        if let maskColor = maskColor {
    //            SVProgressHUD.setBackgroundLayerColor(maskColor)
    //        }
    //
    //        if let style = style {
    //            SVProgressHUD.setDefaultStyle(style)
    //        }
    //
    //        if let status = status {
    //            SVProgressHUD.show(withStatus: status);
    //        } else {
    //            SVProgressHUD.show()
    //        }
    //    }
    //
    //    static func disableActivityIndicator (_ view: UIView) {
    //        SVProgressHUD.dismiss();
    //    }
    
    //    static func enableOrUpdateActivityIndicator (view: UIView,
    //                                                 mode: MBProgressHUDMode?,
    //                                                 title: String?) {
    //
    //        // If a HUD is already visible, then update the mode and text
    //        if let hud = MBProgressHUD(for: view) {
    //
    //            if let mode = mode {
    //                hud.mode = mode
    //            }
    //
    //            if let title = title {
    //                hud.label.text = title
    //            }
    //
    //            return;
    //        }
    //
    //        let hud = MBProgressHUD.showAdded(to: view, animated: true)
    //        hud.isExclusiveTouch = true
    //
    //        // Will look best, if we set a minimum size.
    //        hud.minSize = CGSize(width: 150.0, height: 100.0)
    //
    //        hud.bezelView.layer.cornerRadius = 5.0
    //        hud.bezelView.color = UIColor.white
    //
    //        hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.1)
    //        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
    //
    //        if let mode = mode {
    //            hud.mode = mode
    //        }
    //        
    //        if let title = title {
    //            hud.label.text = title
    //        }
    //    }
    
    static func disableActivityIndicator (_ view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
