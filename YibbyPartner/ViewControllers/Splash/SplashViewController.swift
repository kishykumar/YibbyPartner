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

class SplashViewController: UIViewController {

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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
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
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
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
        self.launchScreenVC = LaunchScreenViewController.init(fromStoryboard: self.storyboard)
        
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
        UIView.animateWithDuration(2.0, delay: 4.0, options: .CurveEaseOut,
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

    func processSyncState (responseData: AnyObject) {
        
        return;
        
        let jsonStatus = responseData[STATUS_JSON_FIELD_NAME]
        
        let jsonBid = responseData[BID_JSON_FIELD_NAME]
        if let data = jsonBid!!.dataUsingEncoding(NSUTF8StringEncoding) {
            let topJson = JSON(data: data)
            if let topBidJson = topJson[BID_JSON_FIELD_NAME].string {
                
                if let bidData = topBidJson.dataUsingEncoding(NSUTF8StringEncoding) {
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
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // show the launch screen
        showLaunchScreen()
//        dismissSplashSnapshot()

        // Clear keychain on first run in case of reinstallation
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey(APP_FIRST_RUN) == nil {
            // Delete values from keychain here
            userDefaults.setValue(APP_FIRST_RUN, forKey: APP_FIRST_RUN)
            LoginViewController.removeKeyChainKeys()
        }

        // register for push notification
        registerForPushNotifications()
        
        var syncSuccess = false
        let client: BAAClient = BAAClient.sharedClient()
        client.syncClient(BAASBOX_DRIVER_STRING, completion: {(success, error) -> Void in
            if (error == nil) {
                
                self.processSyncState(success)
                
                DDLogDebug("Sync successful: \(success))")
                syncSuccess = true
            }
            else {
                DDLogDebug("Error in Sync: \(error)")
                syncSuccess = false
            }
            self.syncAPIResponseArrived = true
        })
        
        // wait for requests to finish
        let timeoutDate: NSDate = NSDate(timeIntervalSinceNow: 10.0)
        
        while (self.syncAPIResponseArrived == false ||
                SplashViewController.pushRegisterResponseArrived == false) &&
                (timeoutDate.timeIntervalSinceNow > 0) {
                    
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false)
        }
        
        DDLogDebug("Setup done")
        
        // TODO:
        if (syncSuccess == false) {
            
        }
        
        if (SplashViewController.pushSuccessful == false) {
            
        }
        
        // Setup is complete, we should move on and show our first screen
        if client.isDriverAuthenticated() {
            DDLogVerbose("Driver already authenticated");
            // no need to do anything if user is already authenticated
            appDelegate.initializeMainViewController()
            self.presentViewController(appDelegate.centerContainer!, animated: false, completion: nil)

//            self.performSegueWithIdentifier("mainFromSplashSegue", sender: nil)
            removeSplash()
        } else {
            DDLogVerbose("Driver NOT authenticated");
            
            self.performSegueWithIdentifier("loginFromSplashSegue", sender: nil)
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
