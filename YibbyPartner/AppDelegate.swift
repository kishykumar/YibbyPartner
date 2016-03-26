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
    let APP_FIRST_RUN = "FIRST_RUN"

    let GOOGLE_API_KEY_IOS = "AIzaSyAg47Gp0GvI6myz-sZZfKJ1fPtx0wUBMjU"
    let BAASBOX_APPCODE = "1234567890"
    let BAASBOX_URL = "http://sandbox1-env.us-west-1.elasticbeanstalk.com"
    
    var centerContainer: MMDrawerController?
    
    var pushController: PushController =  PushController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Configure Baasbox
        BaasBox.setBaseURL(BAASBOX_URL, appCode: BAASBOX_APPCODE)
        
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
        
        // Register for remote notifications
        PushController.registerForPushNotifications()
        
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        // [END start_gcm_service]

        //Clear keychain on first run in case of reinstallation
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey(APP_FIRST_RUN) == nil {
            // Delete values from keychain here
            userDefaults.setValue(APP_FIRST_RUN, forKey: APP_FIRST_RUN)
            LoginViewController.removeKeyChainKeys()
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let client: BAAClient = BAAClient.sharedClient()
        if client.isDriverAuthenticated() {
            // no need to do anything if user is already authenticated
            initializeMainViewController()
            window!.rootViewController = centerContainer
        } else {
            //not logged in
            let (retrievedEmailAddress, retrievedPassword) = LoginViewController.getKeyChainKeys()
            
            // Check if user entered credentials once
            if (retrievedEmailAddress != nil && retrievedPassword != nil) {
                // try to login
                loginUser(retrievedEmailAddress!, passwordi: retrievedPassword!)
            } else {
                // Show the LoginViewController View
                window!.rootViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewControllerIdentifier") as! LoginViewController;
            }
        }
        
        // Present the window
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func initializeMainViewController () {
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
        client.authenticateDriver(usernamei, password: passwordi, completion: {(success, error) -> Void in
            if (success) {
                print("logged in automatically in else case: \(success)")
            }
            else {
                print("error in logging in user automatically\(error)")
            }
        })
    }
    
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(NSError error) -> Void in
                    if (error != nil) {
                        // Treat the "already subscribed" error more gently
                        if error.code == 3001 {
                            print("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            print("Subscription failed: \(error.localizedDescription)");
                        }
                    } else {
                        self.subscribedToTopic = true;
                        NSLog("Subscribed to \(self.subscriptionTopic)");
                    }
            })
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    // [START connect_gcm_service]
    func applicationDidBecomeActive(application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connectWithHandler({
            (NSError error) -> Void in
            if error != nil {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
    }
    // [END connect_gcm_service]

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_apns_token]
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
            
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
                print("enabled push notifications for this user")
            }
            else {
                print("error enabling push notifications + \(error)")
            }
        })
    }
    
    // [START receive_apns_token_error]
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
            print("Registration for remote notification failed with error: \(error.localizedDescription)")
            // [END receive_apns_token_error]
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                registrationKey, object: nil, userInfo: userInfo)
    }
    
    
    // GCM Registration Handler
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken

            // enable push notification
            enablePushNotificationsFromServer(registrationToken)

            print("Registration Token: \(registrationToken)")
            //            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
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
                        
            // This works only if the app started the GCM service
            GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            
            // Handle the received message
            NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                userInfo: userInfo)
            
            self.pushController.receiveRemoteNotification(userInfo)
    }
    
    func application( application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
        fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
            
            // This works only if the app started the GCM service
            GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            
            // Handle the received message
            NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                userInfo: userInfo)
            
            self.pushController.receiveRemoteNotification(userInfo)
            
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

