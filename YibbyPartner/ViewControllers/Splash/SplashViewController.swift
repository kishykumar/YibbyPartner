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
    
    var syncAPIResponseArrived: Bool = false
    static var pushRegisterResponseArrived: Bool = false
    static var pushSuccessful: Bool = false
    
    // MARK: view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSplash()
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
    
    
    // Register for remote notifications
    func registerForPushNotifications () {
        PushController.registerForPushNotifications()
    }

    func processSyncState (_ responseData: AnyObject) {
        
        return;
        
        let jsonStatus = responseData[STATUS_JSON_FIELD_NAME]
        
        let jsonBid = responseData[BID_JSON_FIELD_NAME]
        
        guard let jsonBidString = jsonBid as? String else {
            DDLogVerbose("Returning because of JSON bid string: \(jsonBid)")
            return;
        }
        
        if let dataFromString = jsonBidString.data(using: .utf8, allowLossyConversion: false) {
            let topJson = JSON(data: dataFromString)
            if let topBidJson = topJson[BID_JSON_FIELD_NAME].string {
                
                if let bidData = topBidJson.data(using: String.Encoding.utf8) {
                    let bidJson = JSON(data: bidData)
                    
                    switch bidJson[BID_JSON_FIELD_NAME] as! String {
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func doSetup () {
        
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
//        dismissSplashSnapshot()

        // Clear keychain on first run in case of reinstallation
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: APP_FIRST_RUN) == nil {
            // Delete values from keychain here
            userDefaults.setValue(APP_FIRST_RUN, forKey: APP_FIRST_RUN)
            LoginViewController.removeLoginKeyChainKeys()
        }

        // register for push notification
        registerForPushNotifications()
        
        var syncSuccess = false
        let client: BAAClient = BAAClient.shared()
        client.syncClient(BAASBOX_DRIVER_STRING, completion: {(success, error) -> Void in
            if (success != nil) {
                
                self.processSyncState(success as AnyObject)
                
                DDLogDebug("Sync successful: \(success))")
                syncSuccess = true
            }
            else if (error != nil) {
                DDLogDebug("Error in Sync: \(error)")
                syncSuccess = false
            }
            self.syncAPIResponseArrived = true
        })
        
        // wait for requests to finish
        let timeoutDate: Date = Date(timeIntervalSinceNow: 10.0)
        
        while (self.syncAPIResponseArrived == false ||
                SplashViewController.pushRegisterResponseArrived == false) &&
                (timeoutDate.timeIntervalSinceNow > 0) {
                    
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, false)
        }
        
        DDLogDebug("Setup done")
        
        // TODO:
        if (syncSuccess == false) {
            
        }
        
        if (SplashViewController.pushSuccessful == false) {
            
        }
        
        // Setup is complete, we should move on and show our first screen
        if client.isDriverAuthenticated() {
            DDLogVerbose("Driver already authenticated")
            
            // Sync the client
            // async_call {
            //   if (!finishedRegistration)
            //     show the registration initial controller
            //   else if (!registrationApproved)
            //     show the approvalPending controller
            //   else {
            //     Depending upon the client show the appropriate controller
            //       (show the main view controller, driverEnRoute, Ride...)
            //   }
            // }
            
            // no need to do anything if user is already authenticated
            MainViewController.initMainViewController(self, animated: false)
            removeSplash()
        } else {
            DDLogVerbose("Driver NOT authenticated");
            
            let signupStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.SignUp, bundle: nil)
            self.present(signupStoryboard.instantiateInitialViewController()!, animated: false, completion: nil)
            
            removeSplash()
        }
        
        // this is important to mark that the application has been initialized
        appDelegate.initialized = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
