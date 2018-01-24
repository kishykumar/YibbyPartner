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
    static let BAASBOX_INTERNAL_ERROR = -22223

    static func makeWebRequestAndHandleError (_ vc: UIViewController, webRequest:(_ errorBlock: @escaping (BAAObjectResultBlock)) -> Void) {
        
        webRequest({(success, error) -> Void in
            
            if let myNSError = error as NSError? {
                
                if (myNSError.domain == BaasBox.errorDomain()) {
                    switch (myNSError.code) {
                    case WebInterface.BAASBOX_AUTHENTICATION_ERROR:
                        
                        // check for authentication error and redirect the user to Login page (if its not already on the login page)
                        if let loginVC = vc as? LoginViewController {
                            AlertUtil.displayAlertOnVC(loginVC, title: myNSError.localizedDescription, message: "")
                        } else {
                            DDLogVerbose("Error in webRequest1: \(String(describing: error))")
                            let signupStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.SignUp,
                                                                              bundle: nil)
                            
                            vc.present(signupStoryboard.instantiateInitialViewController()!, animated: false, completion: nil)
                        }
                        break
                        
                    case WebInterface.BAASBOX_INTERNAL_ERROR:
                        DDLogVerbose("Internal Error in webRequest2: \(String(describing: error))")
                        AlertUtil.displayAlertOnVC(vc, title: myNSError.localizedDescription, message: "")
                        break
                        
                    default:
                        DDLogVerbose("Error in webRequest3: \(String(describing: error))")
                        AlertUtil.displayAlertOnVC(vc, title: "Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
                    }
                } else {
                    DDLogVerbose("Error in webRequest4: \(String(describing: error))")
                    AlertUtil.displayAlertOnVC(vc, title: myNSError.localizedDescription, message: "")
                }
            }
        })
    }
    
    static func makeWebRequestAndDiscardError (_ webRequest:() -> Void) {
        webRequest()
    }
}

