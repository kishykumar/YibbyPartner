//
//  WebInterface.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 4/18/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import BaasBoxSDK
import CocoaLumberjack

public class WebInterface {
    
    static let BAASBOX_AUTHENTICATION_ERROR = -22222
    
    static func makeWebRequestAndHandleError (vc: UIViewController, webRequest:(errorBlock: (BAAObjectResultBlock)) -> Void) {
        
        webRequest(errorBlock: { (success, error) -> Void in
            
            DDLogVerbose("Error in webRequest: \(error)")
            
            if (error.domain == BaasBox.errorDomain() && error.code ==
                WebInterface.BAASBOX_AUTHENTICATION_ERROR) {
                // check for authentication error and redirect the user to Login page
                
                if let loginViewController = vc.storyboard?.instantiateViewControllerWithIdentifier("LoginViewControllerIdentifier") as? LoginViewController
                {
                    loginViewController.onStartup = false
                    vc.presentViewController(loginViewController, animated: true, completion: nil)
                }
            }
            else {
                Util.displayAlert("Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
            }
        })
    }
    
    static func makeWebRequestAndDiscardError (vc: UIViewController, webRequest:() -> Void) {
        webRequest()
    }
}

