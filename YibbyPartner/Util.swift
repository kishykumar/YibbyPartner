//
//  Util.swift
//  Yibby
//
//  Created by Kishy Kumar on 3/12/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit

class Util {
    static func enableActivityIndicator (view: UIView, tag: Int) {
        // Initiate the activity Indicator
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.tag = tag
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    static func disableActivityIndicator (view: UIView, tag: Int) {
        let activityIndicator: UIActivityIndicatorView = view.viewWithTag(tag) as! UIActivityIndicatorView
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        activityIndicator.removeFromSuperview()
    }
    
    static func displayAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
