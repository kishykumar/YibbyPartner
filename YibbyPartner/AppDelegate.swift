 //
//  AppDelegate.swift
//  Example
//
//  Created by Kishy Kumar on 1/9/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import MMDrawerController
import BaasBoxSDK
import CocoaLumberjack
import Fabric
import Crashlytics
 
// TODO: 
// 1. Bug: The timer in offer view controller shows up less on one of the phones
// 2. 
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate {
 //-- we have removed this because we are not sending upstream messages via GCM

    var window: UIWindow?

    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"

    let GOOGLE_API_KEY_IOS = "AIzaSyAg47Gp0GvI6myz-sZZfKJ1fPtx0wUBMjU"
    let BAASBOX_APPCODE = "1234567890"
    let BAASBOX_URL = "http://sandbox1-env.us-west-1.elasticbeanstalk.com"
    
    var centerContainer: MMDrawerController?
    
    var pushController: PushController =  PushController()

    var initialized: Bool = false

    let ddLogLevel: DDLogLevel = DDLogLevel.Warning

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                
        // setup Crashlytics
        Fabric.with([Crashlytics.self])

        // Configure Baasbox
        BaasBox.setBaseURL(BAASBOX_URL, appCode: BAASBOX_APPCODE)
        
        // setup logger
        DDLog.addLogger(DDTTYLogger.sharedInstance(), withLevel: DDLogLevel.All) // TTY = Xcode console
        DDLog.addLogger(DDASLLogger.sharedInstance(), withLevel: DDLogLevel.All) // ASL = Apple System Logs
        DDTTYLogger.sharedInstance().logFormatter = LogFormatter() // print filename, line#
        DDASLLogger.sharedInstance().logFormatter = LogFormatter() // print filename, line#

        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.logFormatter = LogFormatter() // print filename, line#
        fileLogger.rollingFrequency = 60*60*24  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)

        // setup LocationService
        LocationService.sharedInstance().setupLocationManager()

        // setup MapService
        MapService.sharedInstance().setupMapService()
        
        DDLogDebug("LaunchOptions \(launchOptions)");
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(GOOGLE_API_KEY_IOS)
        
        // [START_EXCLUDE]
        // Configure the Google context: parses the GoogleService-Info.plist, and initializes
        // the services that have entries in the file
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        // [END_EXCLUDE]
        
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        // [END start_gcm_service]
        
        return true
    }
    
    func initializeMainViewController () {
        DDLogVerbose("Initializing MainViewController");

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let centerController = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewControllerIdentifier") as! MainViewController;
        
        let centerNav = UINavigationController(rootViewController: centerController)
        
        let leftController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftNavDrawerViewControllerIdentifier") as! LeftNavDrawerViewController;
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftController)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.None
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
    }
    
    // BaasBox login user
    func loginUser(usernamei: String, passwordi: String) {
        let client: BAAClient = BAAClient.sharedClient()
        DDLogVerbose("Logging in user with username \(usernamei)")
        client.authenticateCaber("driver", username: usernamei, password: passwordi, completion: {(success, error) -> Void in
            if (success) {
                DDLogVerbose("logged in automatically in else case: \(success)")
            }
            else {
                DDLogVerbose("error in logging in user automatically\(error)")
            }
        })
    }
    
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(error) -> Void in
                    if (error != nil) {
                        // Treat the "already subscribed" error more gently
                        if error.code == 3001 {
                            DDLogVerbose("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            DDLogVerbose("Subscription failed: \(error.localizedDescription)");
                        }
                    } else {
                        self.subscribedToTopic = true;
                        DDLogVerbose("Subscribed to \(self.subscriptionTopic)");
                    }
            })
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        DDLogDebug("Called");
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

        if let vvc = window!.visibleViewController as? OfferViewController {
            DDLogDebug("Saving the timer")
            vvc.saveOfferTimer()
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        DDLogDebug("Called");
        
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }

    func applicationWillEnterForeground(application: UIApplication) {
        DDLogDebug("Called");

        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    // [START connect_gcm_service]
    func applicationDidBecomeActive(application: UIApplication) {
        
        DDLogDebug("Called");
        
        // TODO: check if badges are active: badges = 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                DDLogWarn("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                DDLogDebug("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
        
        if let vvc = window!.visibleViewController as? OfferViewController {
            DDLogVerbose("Restoring the timer")
            vvc.restoreOfferTimer()
        }
        
        // process a saved notification, if any
        pushController.processSavedNotification()
    }
    // [END connect_gcm_service]

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_apns_token]
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
        
            DDLogDebug("Application device token \(deviceToken)");

            self.pushController.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)

            // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
            let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
            instanceIDConfig.delegate = self
            
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            
            GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
            registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
                kGGLInstanceIDAPNSServerTypeSandboxOption:true]
            GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
            // [END get_gcm_reg_token]
    }
    
    func enablePushNotificationsFromServer (gcmToken: String) {
        let client: BAAClient = BAAClient.sharedClient();

        client.enableDriverPushNotificationsForGCM(gcmToken, completion: { (success, error) -> Void in
            if (success) {
                DDLogVerbose("enabled push notifications: Success")
                SplashViewController.pushSuccessful = true
            }
            else {
                DDLogWarn("Error: enabled push notifications: \(error)")
                
                // tell Splash that push registration was not successful
                SplashViewController.pushSuccessful = false
            }
            SplashViewController.pushRegisterResponseArrived = true
        })
    }
    
    // [START receive_apns_token_error]
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
        DDLogWarn("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
//        let userInfo = ["error": error.localizedDescription]
//            NSNotificationCenter.defaultCenter().postNotificationName(
//                registrationKey, object: nil, userInfo: userInfo)
        
        // tell Splash that push registration was not successful
        SplashViewController.pushSuccessful = false
        SplashViewController.pushRegisterResponseArrived = true
    }
    
    
    // GCM Registration Handler
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken

            // enable push notification
            enablePushNotificationsFromServer(registrationToken)

            DDLogDebug("Registration Token: \(registrationToken)")
            //            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            DDLogWarn("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
            
            // tell Splash that push registration was not successful
            SplashViewController.pushSuccessful = false
            SplashViewController.pushRegisterResponseArrived = true
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        DDLogInfo("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    // [END on_token_refresh]
    
    func sendGCMTokenToServer() {
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    // [START ack_message_reception]
    func application( application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        DDLogDebug("Remote push received1: \(userInfo)")

        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            
        // Handle the received message
//            NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
//                userInfo: userInfo)
        
        self.pushController.receiveRemoteNotification(application, notification: userInfo)
    }
    
    func application( application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
        fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {

        DDLogDebug("Remote push received2: \(userInfo)")
        
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        // Handle the received message
//        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
//            userInfo: userInfo)
        
        self.pushController.receiveRemoteNotification(application, notification: userInfo)
    
        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
        handler(UIBackgroundFetchResult.NoData);
    }

    func willSendDataMessageWithID(messageID: String!, error: NSError!) {
        if (error != nil) {
            // Failed to send the message.
        } else {
            // Will send message, you can save the messageID to track the message
        }
    }
    
    func didSendDataMessageWithID(messageID: String!) {
        // Did successfully send message identified by messageID
    }


    func didDeleteMessagesOnServer() {
        // Some messages sent to this device were deleted on the GCM server before reception, likely
        // because the TTL expired. The client should notify the app server of this, so that the app
        // server can resend those messages.
    }
}

 public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                if let mmd = vc as? MMDrawerController {
                    return UIWindow.getVisibleViewControllerFrom(mmd.centerViewController)
                }
                return vc
            }
        }
    }
 }
 
 // used to dismiss keyboard when user taps anywhere on the screen
 extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
 }
 
 