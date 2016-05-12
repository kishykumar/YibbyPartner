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
    static func enableActivityIndicator (view: UIView, tag: Int) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.show();
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    static func disableActivityIndicator (view: UIView, tag: Int) {
        SVProgressHUD.dismiss();
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    static func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        if let vvc = appDelegate.window?.visibleViewController {
            vvc.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    static func displayAlertOnVC(vc: UIViewController, title: String, message: String) {
        DDLogVerbose("displayAlertOnVC: \(vc)")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func displaySettingsAlert(title: String, message: String, showOk: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Add Settings
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        // Add OK
        if (showOk) {
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
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
                Util.displaySettingsAlert("Location services disabled",
                                          message: "Please provide Yibby access to location services in the Settings -> Privacy -> Location Services",
                                          showOk: false)
                return false;
                break
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                break
            }
        } else {
            Util.displaySettingsAlert("Location services disabled",
                                      message: "Please turn on location services in the Settings -> Privacy -> Location Services",
                                      showOk: false)
            return false;
        }
        return true;
    }
    
    static func diffFromCurTimeISO (fromIsoTime: String) -> NSTimeInterval {

        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        
        let isoNSDate: NSDate = formatter.dateFromString(fromIsoTime)!
        
        // Get the current time
        let curTime = NSDate()
        
        let secondsBetween: NSTimeInterval = curTime.timeIntervalSinceDate(isoNSDate)
        return secondsBetween
    }
    
    static func diffFromCurTime (fromTime: NSDate) -> NSTimeInterval {

        // Get the current time
        let curTime = NSDate()
        
        let secondsBetween: NSTimeInterval = curTime.timeIntervalSinceDate(fromTime)
        return secondsBetween
    }
}
