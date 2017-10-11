//
//  WebInterface.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 4/18/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD
import BaasBoxSDK
import CocoaLumberjack

open class WebInterface {
    
    static let BAASBOX_AUTHENTICATION_ERROR = -22222
    
    static func makeWebRequestAndHandleError (_ vc: UIViewController, webRequest:(_ errorBlock: @escaping (BAAObjectResultBlock)) -> Void) {
        
        webRequest({ (success, error) -> Void in
            
            DDLogVerbose("Error in webRequest: \(error)")
            
            if ((error as! NSError).domain == BaasBox.errorDomain() && (error as! NSError).code ==
                WebInterface.BAASBOX_AUTHENTICATION_ERROR) {
                // check for authentication error and redirect the user to Login page
                
                let loginStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Login, bundle: nil)

                if let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as? LoginViewController
                {
                    loginViewController.onStartup = false
                    vc.present(loginViewController, animated: true, completion: nil)
                }
            }
            else {
                AlertUtil.displayAlert("Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
            }
        })
    }
    
    static func makeWebRequestAndDiscardError (_ webRequest:() -> Void) {
        webRequest()
    }
}

