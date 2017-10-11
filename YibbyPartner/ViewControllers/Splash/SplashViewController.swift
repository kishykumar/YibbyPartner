//
//  SplashViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 5/19/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import LaunchScreen
import BaasBoxSDK
import MMDrawerController
import SwiftyJSON

public enum AppInitReturnCode: Int {
    case success = 0
    case error
    case loginError
}

public struct AppInitNotifications {
    static let pushStatus = TypedNotification<AppInitReturnCode>(name: "com.Yibby.SplashViewController.pushSuccess")
}

class SplashViewController: BaseYibbyViewController {

    // MARK: Properties
    
    static let SPLASH_SCREEN_TAG = 10
    
    let APP_FIRST_RUN = "FIRST_RUN"
    let STATUS_JSON_FIELD_NAME = "status"
    let BID_JSON_FIELD_NAME = "bid"
    let OFFER_JSON_FIELD_NAME = "status"
    let RIDE_JSON_FIELD_NAME = "ride"
    
    var launchScreenVC: LaunchScreenViewController?
    var snapshot: UIImage?
    var imageView: UIImageView?
    fileprivate var pushStatusObserver: NotificationObserver?

    let ERROR_TEXTVIEW_TAG = 100

    // MARK: view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSplash()
        setupNotificationObservers()
    }
    
    deinit {
        DDLogVerbose("SplashViewController Deinit")
        removeNotificationObservers()
    }
    
    fileprivate func setupNotificationObservers() {
        
        pushStatusObserver = NotificationObserver(notification: AppInitNotifications.pushStatus) { [unowned self] returnCode in
            DDLogVerbose("pushStatusObserver status: \(returnCode)")
            
            switch (returnCode) {
            case .error:
                self.pushRegistrationErrorCallback()
                break
                
            case .success:
                self.pushRegistrationSuccessCallback()
                break
                
            case .loginError:
                self.pushLoginErrorCallback()
                break
                
            default: break
            }
        }
    }

    fileprivate func removeNotificationObservers() {
        pushStatusObserver?.removeObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func processSyncState (_ responseData: AnyObject) {
//        
//        return;
//        
//        let jsonStatus = responseData[STATUS_JSON_FIELD_NAME]
//        
//        let jsonBid = responseData[BID_JSON_FIELD_NAME]
//        
//        guard let jsonBidString = jsonBid as? String else {
//            DDLogVerbose("Returning because of JSON bid string: \(jsonBid)")
//            return;
//        }
//        
//        if let dataFromString = jsonBidString.data(using: .utf8, allowLossyConversion: false) {
//            let topJson = JSON(data: dataFromString)
//            if let topBidJson = topJson[BID_JSON_FIELD_NAME].string {
//                
//                if let bidData = topBidJson.data(using: String.Encoding.utf8) {
//                    let bidJson = JSON(data: bidData)
//                    
//                    switch bidJson[BID_JSON_FIELD_NAME] as! String {
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//    }
    
    func doSetup () {
        DDLogVerbose("Called");

        ///////////////////////////////////////////////////////////////////////////
        // We do the app's initialization in viewDidAppear().
        // 1. Setup Splash Screen
        // 2. Register for remote notifications
        // 3. Sync the app with the webserver by making the http call
        // 4. Segue to the appropriate view controller one all initialization is done
        ///////////////////////////////////////////////////////////////////////////
        
        // Do any additional setup after loading the view.
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // show the launch screen
        showLaunchScreen()
        
        // Clear keychain on first run in case of reinstallation
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: APP_FIRST_RUN) == nil {
            // Delete values from keychain here
            userDefaults.setValue(APP_FIRST_RUN, forKey: APP_FIRST_RUN)
            LoginViewController.removeLoginKeyChainKeys()
        }

        let client: BAAClient = BAAClient.shared()
        if client.isAuthenticated() {
            DDLogVerbose("User already authenticated");
            
            appDelegate.initializeApp()
            
        } else {
            DDLogVerbose("User NOT authenticated");
            
            let signupStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.SignUp,
                                                              bundle: nil)
            
            self.present(signupStoryboard.instantiateInitialViewController()!, animated: false, completion: nil)
            
            removeSplash()
        }
    }
    // MARK: Helpers
    
    func showLaunchScreen() {
        let v: UIView = self.launchScreenVC!.view!
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // add the view to window
        appDelegate.window?.addSubview(v)
    }
    
    func dismissSplashSnapshot() {
        imageView!.removeFromSuperview()
        imageView = nil
    }
    
    func initSplash () {
        DDLogVerbose("Adding the splash screen snapshot");
        
        // Instantiate a LaunchScreenViewController which will insert the UIView contained in our Launch Screen XIB
        // as a subview of it's view.
        self.launchScreenVC = LaunchScreenViewController.init(from: self.storyboard)
        
        // Take a snapshot of the launch screen. You could do this at any time you like.
        //        self.snapshot = self.launchScreenVC!.snapshot()
        let v: UIView = self.launchScreenVC!.view!
        
        // To avoid the glitch, add the image during viewDidLoad and remove it when viewDidAppear
        //        imageView = UIImageView(image: snapshot)
        //        imageView!.userInteractionEnabled = true
        //        imageView!.frame = self.view.bounds
        view!.addSubview(v)
    }
    
    func removeSplash () {
        
        // Initialize the status bar before we show the first screen
        setStatusBar()
        
        let v: UIView = self.launchScreenVC!.view!
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut,
                       animations: {() -> Void in
                        v.alpha = 0.0
        },
           completion: {(finished: Bool) -> Void in
            DDLogVerbose("Removing the splash screen");
            v.removeFromSuperview()
        }
        )
    }
    
    func pushRegistrationSuccessCallback() {
        DDLogDebug("pushRegistrationSuccessCallback Called")
        removeSplash()
    }
    
    func pushRegistrationErrorCallback() {
        
        let v: UIView = self.launchScreenVC!.view!
        let label: UITextView = v.viewWithTag(ERROR_TEXTVIEW_TAG) as! UITextView
        label.isHidden = false
        
        // earlier we were removing the splash, now just showing the error
        //        removeSplash()
    }
    
    func pushLoginErrorCallback() {
        removeSplash()
        
        let signupStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.SignUp,
                                                          bundle: nil)
        
        self.present(signupStoryboard.instantiateInitialViewController()!, animated: false, completion: nil)
    }
    
    func setStatusBar() {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        //if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appDarkGreen1()
        //}
        
        // status bar text color
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
    }
}
