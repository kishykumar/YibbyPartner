 //
//  AppDelegate.swift
//  Yibby
//
//  Created by Kishy Kumar on 1/9/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import GoogleMaps
import MMDrawerController
import BaasBoxSDK
import CocoaLumberjack
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
//import Firebase
import ObjectMapper
import Instabug

// TODO: 
// 1. Bug: The timer in offer view controller shows up less on one of the phones
// 2. Stop location updates in the background if no driver activity for the last 10 minutes
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate {

    var window: UIWindow?

    fileprivate var isSandbox = true

    fileprivate var connectedToGCM = false
    fileprivate var subscribedToTopic = false
    fileprivate var gcmSenderID: String?
    fileprivate var registrationToken: String?
    fileprivate var registrationOptions = [String: AnyObject]()
    
    fileprivate let registrationKey: String = "onRegistrationCompleted"
    fileprivate let messageKey: String = "onMessageReceived"
    fileprivate let subscriptionTopic: String = "/topics/global"

    fileprivate let GOOGLE_API_KEY_IOS: String = "AIzaSyAg47Gp0GvI6myz-sZZfKJ1fPtx0wUBMjU"
    fileprivate let BAASBOX_APPCODE: String = "1234567890"

    fileprivate var BAASBOX_URL: String {
        return
            ((self.isSandbox) ?
            ("http://test.yibbyapp.com") :
           // ("http://3a15b3cb.ngrok.io") :
            ("http://api.yibbyapp.com"))
    }
    
    //fileprivate let BAASBOX_URL = "http://42f3eb3a.ngrok.io"

    var centerContainer: MMDrawerController?
    var pushController: PushController =  PushController()
    var initialized: Bool = false

    // App initialization variables
    fileprivate var appInitDispatchGroup: DispatchGroup?
    fileprivate var pushError: Error? = nil
    fileprivate var syncError: Error? = nil
    fileprivate var loginError: Error? = nil
    fileprivate var handlePushStatusCodeBlock: ((_ isSuccess: Bool, _ error: Error?) -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Setup Instabug
        Instabug.start(withToken: "557f3fb01b544e77a87b9ed4e3906411", invocationEvent: .shake)
        
        // Configure Baasbox
        BaasBox.setBaseURL(BAASBOX_URL, appCode: BAASBOX_APPCODE)
        
        setupLogger()
        setupKeyboardManager()
        setupMapService()
        
        DDLogDebug("LaunchOptions \(String(describing: launchOptions))");

        // Override point for customization after application launch.
        GMSServices.provideAPIKey(GOOGLE_API_KEY_IOS)
        
        //FirebaseApp.configure()
        
        // [START_EXCLUDE]
        // Configure the Google context: parses the GoogleService-Info.plist, and initializes
        // the services that have entries in the file
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        // [END_EXCLUDE]
        
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.default()
        gcmConfig?.receiverDelegate = self
        GCMService.sharedInstance().start(with: gcmConfig)
        // [END start_gcm_service]
        
        // NOTE: Setup Crashlytics the last
        Fabric.with([Crashlytics.self])
        //Fabric.sharedSDK().debug = true

        return true
    }
    
    func setupLogger() {
        
        // setup logger
        if #available(iOS 10.0, *) {
            DDLog.add(DDASLLogger.sharedInstance, with: .all) // ASL = Apple System Logs
        } else {
            DDLog.add(DDASLLogger.sharedInstance, with: .all) // ASL = Apple System Logs
            DDLog.add(DDTTYLogger.sharedInstance, with: .all) // TTY = Xcode console
        }
        
        DDTTYLogger.sharedInstance.logFormatter = LogFormatter() // print filename, line#
        DDASLLogger.sharedInstance.logFormatter = LogFormatter() // print filename, line#
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.logFormatter = LogFormatter() // print filename, line#
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    func setupLocationService() {
        // setup LocationService
        LocationService.sharedInstance().setupLocationManager()
    }
    
    // Register for remote notifications
    fileprivate func registerForPushNotifications () {
        PushController.registerForPushNotifications()
    }

    func setupKeyboardManager() {
        
        // Setup IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func setupMapService() {
        
        // setup MapService
        MapService.sharedInstance().setupMapService()
        
    }
    
    func initializeMainViewController () {

        DDLogVerbose("Initializing MainViewController");

        let appStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.App, bundle: nil)

        let centerController = appStoryboard.instantiateViewController(withIdentifier: "MainViewControllerIdentifier") as! MainViewController;
        
        let centerNav = UINavigationController(rootViewController: centerController)
        
        let drawerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Drawer, bundle: nil)

        let leftController = drawerStoryboard.instantiateViewController(withIdentifier: "LeftNavDrawerViewControllerIdentifier") as! LeftNavDrawerViewController;
        
        centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftController)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode()
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
    }

    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribe(withToken: self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(error) -> Void in
                    if (error != nil) {
                        // Treat the "already subscribed" error more gently
                        if ((error as! NSError).code == 3001) {
                            DDLogVerbose("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            DDLogVerbose("Subscription failed: \((error as! NSError).localizedDescription)");
                        }
                    } else {
                        self.subscribedToTopic = true;
                        DDLogVerbose("Subscribed to \(self.subscriptionTopic)");
                    }
            })
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        DDLogDebug("Called");
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

//        if let vvc = window!.visibleViewController as? OfferViewController {
//            DDLogDebug("Saving the timer")
//            vvc.saveOfferTimer()
//        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DDLogDebug("Called");
        
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DDLogDebug("Called");

        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    // [START connect_gcm_service]
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        DDLogDebug("Called");
        
        // TODO: check if badges are active: badges = 0
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connect(handler: {
            (error) -> Void in
            if error != nil {
                DDLogWarn("Could not connect to GCM: \((error as! NSError).localizedDescription)")
            } else {
                self.connectedToGCM = true
                DDLogDebug("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
        
//        if let vvc = window!.visibleViewController as? OfferViewController {
//            DDLogVerbose("Restoring the timer")
//            vvc.restoreOfferTimer()
//        }
        
        // process a saved notification, if any
        pushController.processSavedNotification()
    }
    // [END connect_gcm_service]

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_apns_token]
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data ) {
        
        DDLogDebug("Application device token \(deviceToken)");

        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,
            kGGLInstanceIDAPNSServerTypeSandboxOption:isSandbox as AnyObject]
        
        // [END get_gcm_reg_token]
        
        sendGCMTokenToServer()
    }
    
    func enablePushNotificationsFromServer (_ gcmToken: String) {
        
        let client: BAAClient = BAAClient.shared();

        client.enableDriverPushNotifications(forGCM: gcmToken, completion: { (success, error) -> Void in
            if (success) {
                DDLogVerbose("enabled push notifications: Success")
                self.pushStatusCallback(isSuccess: true, error: nil)
            }
            else {
                DDLogWarn("Error: enabled push notifications: \(String(describing: error))")
                self.pushStatusCallback(isSuccess: false, error: error)
            }
        })
    }
    
    fileprivate func pushStatusCallback(isSuccess: Bool, error: Error?) {
        
        DispatchQueue.main.async {
            
            if (self.handlePushStatusCodeBlock != nil) {
                
                if let codeBlock = self.handlePushStatusCodeBlock {
                    codeBlock(isSuccess, error)
                }
                
                self.appInitDispatchGroup?.leave()
            }
            
            // This callback should be called just once.
            // There's a bug in iOS 10 that push registration callback is called twice.
            self.handlePushStatusCodeBlock = nil
        }
    }
    
    // [START receive_apns_token_error]
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: Error ) {
        DDLogWarn("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
//        let userInfo = ["error": error.localizedDescription]
//            NSNotificationCenter.defaultCenter().postNotificationName(
//                registrationKey, object: nil, userInfo: userInfo)
        
        self.pushStatusCallback(isSuccess: false, error: error)
    }
    
    
    // GCM Registration Handler
    func registrationHandler(_ registrationToken: String?, error: Error?) {
        
        if let registrationToken = registrationToken {
            self.registrationToken = registrationToken

            // enable push notification
            enablePushNotificationsFromServer(registrationToken)

            //            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
            
        } else {
            DDLogWarn("Registration to GCM failed with error: \((error as? NSError)?.localizedDescription)")
            let userInfo = ["error": (error as? NSError)?.localizedDescription]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
            
            self.pushStatusCallback(isSuccess: false, error: error)
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        DDLogInfo("The GCM registration token needs to be changed.")
        sendGCMTokenToServer()
    }
    
    // [END on_token_refresh]
    
    func sendGCMTokenToServer() {
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    // [START ack_message_reception]
    func application( _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        DDLogDebug("Remote push received1: \(userInfo)")

        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            
        // Handle the received message
//            NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
//                userInfo: userInfo)
        
        self.pushController.receiveRemoteNotification(application, notification: userInfo)
    }
    
    func application( _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler handler: @escaping (UIBackgroundFetchResult) -> Void) {

        DDLogDebug("Remote push received2: \(userInfo)")
        
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        // Handle the received message
//        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
//            userInfo: userInfo)
        
        self.pushController.receiveRemoteNotification(application, notification: userInfo)
    
        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
        handler(UIBackgroundFetchResult.noData);
    }

    func willSendDataMessage(withID messageID: String!, error: NSError!) {
        if (error != nil) {
            // Failed to send the message.
        } else {
            // Will send message, you can save the messageID to track the message
        }
    }
    
    func didSendDataMessage(withID messageID: String!) {
        // Did successfully send message identified by messageID
    }


    func didDeleteMessagesOnServer() {
        // Some messages sent to this device were deleted on the GCM server before reception, likely
        // because the TTL expired. The client should notify the app server of this, so that the app
        // server can resend those messages.
    }
    
    // MARK: - App Initialization
    
    func initializeApp() -> Error? {

        self.appInitDispatchGroup = DispatchGroup()
        
        if let dispatchGroup = self.appInitDispatchGroup {
            
            self.pushError = nil
            self.syncError = nil
            
            // PushNotifications
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                
                // Initialize a callback to be called just once in response to push success, as
                // there's a bug in iOS 10 that push registration callback is called twice.
                self.handlePushStatusCodeBlock = { (isSuccess: Bool, error: Error?) -> Void in
                    
                    if (isSuccess) {
                        
                    } else {
                        self.pushError = error
                    }
                }
                
                self.registerForPushNotifications()
            }
            
            // Payment,Sync
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                self.setupWebserver()
            }
            
            dispatchGroup.wait()

            // Check for errors
            if (self.pushError != nil) {
                DDLogVerbose("Push Error during init \(String(describing: self.pushError))")
                
                return self.pushError;
                //let customizedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to initialize app"])
                //return customizedError;
                
            } else if (self.syncError != nil) {
                DDLogVerbose("Sync Error during init \(String(describing: self.syncError))")
                return self.syncError;
            }
            
            // Schedule on the main thread synchronously
            DispatchQueue.main.sync {
                
                DDLogVerbose("App Initialization successfully complete")
                
                // LocationService
                self.setupLocationService()
                
                var status = YBClient.sharedInstance().status
                let bid = YBClient.sharedInstance().bid
                let bidId = YBClient.sharedInstance().getPersistedBidId()

                // The visible view controller can be splash, login, or signup view controller
                guard let visibleVC = self.window!.visibleViewController else {
                    return;
                }
                
                let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
                
                if (status == .detailsNotSubmitted) {
                    
                    let initialRegisterController = registerStoryboard.instantiateViewController(withIdentifier: "VehicleViewControllerIdentifier") as! VehicleViewController
                    
                    let navController = UINavigationController(rootViewController: initialRegisterController)
                    visibleVC.present(navController, animated: false, completion: nil)
                    
                } else if (status == .notApproved) {
                    let paViewController = registerStoryboard.instantiateViewController(withIdentifier: "PendingApprovalViewControllerIdentifier") as! PendingApprovalViewController
                    
                    visibleVC.present(paViewController, animated: false, completion: nil)
                } else {
                    
                    self.initializeMainViewController()
                    
                    if let centerNav = self.centerContainer?.centerViewController as? UINavigationController {
                        var controllers = centerNav.viewControllers
                        
                        if (status != .offline) {
                            LocationService.sharedInstance().startLocationUpdates()
                        }
                        
                        switch (status) {
                        case .offline:
                            
                            // Remove the bid if it existed
                            if (bidId != nil) {
                                YBClient.sharedInstance().bid = nil
                            }
                            
                            break
                            
                        case .online:
                            
                            // Remove the bid if it existed
                            if (bidId != nil) {
                                YBClient.sharedInstance().bid = nil
                            }
                            
                            break
                            
                        case .offerInProcess:
                            
                            let bidElapsedTime = TimeUtil.diffFromCurTimeISO(bid!.creationTime!)
                            
                            if (bidElapsedTime > MainViewController.BID_NOTIFICATION_EXPIRE_TIME) {
                                DDLogDebug("Bid Discarded CurrentTime: \(Date()) bidTime: \(String(describing: bid!.creationTime)) bidElapsedTime: \(bidElapsedTime)")
                                
                                // Remove the bid if it existed
                                if (bidId != nil) {
                                    YBClient.sharedInstance().bid = nil
                                }
                                
                                // The driver missed responding to the bid
                                // Can't display an alert here if bid is missed because it prevents MainViewController from coming up
                                // TODO: display alert when MainViewController is up
                                
                            } else {
                                
                                // prepare the offerViewController
                                let offerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Offer, bundle: nil)
                                
                                let offerViewController = offerStoryboard.instantiateViewController(withIdentifier: "OfferViewControllerIdentifier") as! OfferViewController
                                
                                let navController = UINavigationController(rootViewController: offerViewController)
                                
                                // start the timer by accouting the time elapsed since the user actually created the bid
                                offerViewController.timerStart = TimeInterval(Int(OfferViewController.OFFER_TIMER_EXPIRE_PERIOD - bidElapsedTime))
                                
                                centerNav.present(navController, animated: true, completion: nil)
                            }
                            
                            break
                            
                        case .driverEnRoute:
                            
                            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
                            
                            let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
                            
                            rideStartViewController.controllerState = .driverEnRoute
                            
                            controllers.append(rideStartViewController)
                            
                            break
                            
                        case .driverArrived:
                            
                            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
                            
                            let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
                            
                            rideStartViewController.controllerState = .driverArrived
                            
                            controllers.append(rideStartViewController)
                            
                            break
                            
                        case .rideStart:
                            
                            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
                            
                            let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
                            
                            rideStartViewController.controllerState = .rideStart
                            
                            controllers.append(rideStartViewController)
                            
                            break
                            
                        case .rideEnd:
                            
                            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
                            
                            let rideEndViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideEndViewControllerIdentifier") as! RideEndViewController
                            
                            controllers.append(rideEndViewController)
                            
                            break
                            
                        case .rideDriverCancelled:
                            
                            // Remove the bid if it existed
                            let bidId = YBClient.sharedInstance().getPersistedBidId()
                            if (bidId != nil) {
                                YBClient.sharedInstance().bid = nil
                            }
                            
//                            // Can't show an Alert
//                            AlertUtil.displayAlertOnVC(centerNav.topViewController!, title: "You had cancelled the previous ride.",
//                                                       message: "",
//                                                       completionBlock: {() -> Void in
//                            })
                            
                        case .rideRiderCancelled:
                            
                            // Remove the bid if it existed
                            let bidId = YBClient.sharedInstance().getPersistedBidId()
                            if (bidId != nil) {
                                YBClient.sharedInstance().bid = nil
                            }

//                            Can't show alert as it interferes with MainViewController instatiation
//                            AlertUtil.displayAlertOnVC(centerNav.topViewController!, title: "Unfortunately, your ride has been cancelled by the rider.",
//                                                       message: "You will be compensated according to our Terms & Conditions.",
//                                                       completionBlock: {() -> Void in
//                            })
                            
                        default:
                            // nothing to do here. MainViewController will be shown.
                            break
                        }
                        
                        centerNav.setViewControllers(controllers, animated: true)
                        visibleVC.present(self.centerContainer!, animated: true, completion: nil)
                    }
                }

                self.initialized = true
            }
        }
        return nil
    }
 
    fileprivate func setupWebserver() {
        
        let client: BAAClient = BAAClient.shared()
        let syncDispatchGroup: DispatchGroup = DispatchGroup()
        
        syncDispatchGroup.enter()

        //YBClient.sharedInstance().bid = nil // do this to remove app's bid state
        let bidId = YBClient.sharedInstance().getPersistedBidId()
        client.syncClient(BAASBOX_DRIVER_STRING, bidId: bidId, completion: { (success, error) -> Void in
            
            if let success = success {
                
                let syncModel = Mapper<YBSync>().map(JSONObject: success)
                
                if let syncData = syncModel {
                    
                    DDLogVerbose("syncApp syncdata for bidid: \(String(describing: bidId))")
                    dump(syncData)
                    
                    YBClient.sharedInstance().syncClient(syncData)

                    // Initialize Crashlytics username, email, identifier
                    Crashlytics.sharedInstance().setUserName(client.currentUser.username())
                    Crashlytics.sharedInstance().setUserEmail(syncData.profile?.personal?.emailId)
                    Crashlytics.sharedInstance().setUserIdentifier(client.currentUser.authenticationToken)
                    Crashlytics.sharedInstance().setObjectValue(bidId, forKey: "APP_BID_ID")
                    Crashlytics.sharedInstance().setObjectValue(syncData.status?.rawValue, forKey: "CLIENT_STATUS")
                    
                } else {
                    DDLogError("Error in parsing sync data: \(String(describing: error))")
                    self.syncError = error
                }
            } else {
                DDLogVerbose("syncClient failed: \(String(describing: error))")
                self.syncError = error
            }
            
            syncDispatchGroup.leave()
        })
        
        syncDispatchGroup.wait()
        
        if (self.syncError != nil) {
            self.appInitDispatchGroup?.leave()
            return;
        }
        
        DDLogVerbose("Success in SetupWebserver")
        self.appInitDispatchGroup?.leave()
    }
}

 public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
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
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
//                                                                 action: #selector(UIViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
 }
 
 
