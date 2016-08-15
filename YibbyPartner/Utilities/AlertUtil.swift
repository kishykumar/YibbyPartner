//
//  AlertUtil.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/8/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import BaasBoxSDK
import CocoaLumberjack

public typealias AlertUtilCompletionCallback = () -> Void

public class AlertUtil {
    
    static func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        alert.addAction(UIAlertAction(title: InterfaceString.OK, style: .Default, handler: { (action) -> Void in
        }))
        
        if let vvc = appDelegate.window?.visibleViewController {
            vvc.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    static func displayAlertOnVC(vc: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: InterfaceString.OK, style: .Default, handler: { (action) -> Void in
        }))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func displayChoiceAlert(title: String, message: String,
                                   completionActionString: String,
                                   completionBlock: AlertUtilCompletionCallback) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add OK
        alert.addAction(UIAlertAction(title: completionActionString,
            style: .Default,
            handler: { (action) -> Void in
                completionBlock()
        }))
        
        // Add Cancel
        alert.addAction(UIAlertAction(title: InterfaceString.Cancel, style: .Default,
            handler: { (action) -> Void in
        }))
        
        if let vvc = appDelegate.window?.visibleViewController {
            vvc.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    static func displaySettingsAlert(title: String, message: String, showOk: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Add Settings
        alert.addAction(UIAlertAction(title: InterfaceString.SettingsAction, style: .Default, handler: { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        // Add OK
        if (showOk) {
            alert.addAction(UIAlertAction(title: InterfaceString.OK, style: .Default, handler: { (action) -> Void in
            }))
        }
        
        if let vvc = appDelegate.window?.visibleViewController {
            vvc.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    static func displayLocationAlert () -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                
            case .NotDetermined, .Restricted, .Denied:
                AlertUtil.displaySettingsAlert("Location services disabled",
                                          message: "Please provide Yibby access to location services in the Settings -> Privacy -> Location Services",
                                          showOk: false)
                return false;
                break
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                break
            }
        } else {
            AlertUtil.displaySettingsAlert("Location services disabled",
                                      message: "Please turn on location services in the Settings -> Privacy -> Location Services",
                                      showOk: false)
            return false;
        }
        return true;
    }
}
