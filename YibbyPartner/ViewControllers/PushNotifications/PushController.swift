//
//  PushController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/9/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import SwiftyJSON
import MMDrawerController
import CocoaLumberjack

@objc public protocol PushControllerProtocol {
    func receiveRemoteNotification(_ application: UIApplication, notification:[AnyHashable: Any])
}

open class PushController: NSObject, PushControllerProtocol {
    
    let BID_MESSAGE_TYPE = "BID"
    let RIDE_START_MESSAGE_TYPE = "RIDE_START"
    let DRIVER_EN_ROUTE_MESSAGE_TYPE = "DRIVER_EN_ROUTE"
    let OFFER_REJECTED_MESSAGE_TYPE = "OFFER_REJECTED"
    let RIDE_CANCELLED_MESSAGE_TYPE = "RIDE_CANCELLED"
    
    let MESSAGE_JSON_FIELD_NAME = "message"
    let CUSTOM_JSON_FIELD_NAME = "custom"
    let BID_JSON_FIELD_NAME = "bid"
    let RIDE_JSON_FIELD_NAME = "ride"
    let ID_JSON_FIELD_NAME = "id"
    let BID_ID_JSON_FIELD_NAME = "bidId"
    let GCM_MSG_ID_JSON_FIELD_NAME = "gcm.message_id"
    
    var savedNotification: [AnyHashable: Any]?
    
    let BID_NOTIFICATION_EXPIRE_TIME: TimeInterval = 30 // seconds
    
    var mLastGCMMsgId: String?
    
    public override init() {
        super.init()
    }

    //MARK: Receiving remote notification
    open func receiveRemoteNotification(_ application: UIApplication, notification: [AnyHashable: Any]) {
        
// TODO: Add this code
//        if (DRIVER IS OFFLINE) {
//          return;
//        }
    
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if (!appDelegate.initialized) {
            return;
        }
        
        if application.applicationState == .background {
            //opened from a push notification when the app was on background
            DDLogDebug("App in BG")
            handleBgNotification(notification)
        }
        else if (application.applicationState == .inactive) {
            // ignore the BID message
            DDLogDebug ("App in inactive state")
            handleBgNotification(notification)
        }
        else { // App in foreground
            DDLogDebug("App in FG")
            handleFgNotification(notification)
        }
    }

    func handleBgNotification (_ notification: [AnyHashable: Any]) {
        
        // save the most recent push message
        DDLogDebug("Save push message in BG from \(savedNotification) to \(notification)")
        
        savedNotification = [AnyHashable: Any]()
        savedNotification = notification
    }
    
    func handleFgNotification (_ notification: [AnyHashable: Any]) {
        // show the message if it's not late
        processNotification(notification)
    }
    
    func processSavedNotification() {
        
        DDLogDebug("Called")
        
        if let notification = savedNotification {
            DDLogDebug("Processing saved notification: \(notification)")

            processNotification(notification)
            
            // remove the saved notification
            savedNotification = nil
        } else {
            DDLogDebug("No saved notification found")
        }
    }
    
    func processNotification (_ notification: [AnyHashable: Any]) {
        
        DDLogVerbose("Called")
        
        // handle bid
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if notification[MESSAGE_JSON_FIELD_NAME] == nil {
            DDLogDebug("No notification message found")
            return;
        }
        
        // check if we have already processed this push message
        guard let lastGCMMsgId = notification[GCM_MSG_ID_JSON_FIELD_NAME] as? String else {
            DDLogDebug("Exiting because lastGCMMsgId is nil: \(notification)")
            return;
        }
        
        if (mLastGCMMsgId != nil) && (mLastGCMMsgId == lastGCMMsgId) {
            DDLogDebug("Already processed the push message: \(notification)")
            return;
        }
        
        mLastGCMMsgId = notification[GCM_MSG_ID_JSON_FIELD_NAME] as? String
        
        if (appDelegate.centerContainer == nil) {
            // this might happen during startup
            DDLogDebug("Discarded the notification because centerContainer nil")
            return;
        }
        
        if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
            
            let jsonCustom = notification[CUSTOM_JSON_FIELD_NAME]
            
            guard let jsonCustomString = jsonCustom as? String else {
                DDLogVerbose("Returning because of JSON custom string: \(jsonCustom)")
                return;
            }
            
            switch notification[MESSAGE_JSON_FIELD_NAME] as! String {
                
            case BID_MESSAGE_TYPE:
                DDLogVerbose("BID message RCVD")

                let bid = Bid(JSONString: jsonCustomString)!

                let bidElapsedTime = TimeUtil.diffFromCurTimeISO(bid.creationTime!)
                
                if (bidElapsedTime > BID_NOTIFICATION_EXPIRE_TIME) {
                    DDLogDebug("Bid Discarded CurrentTime: \(Date()) bidTime: \(bid.creationTime) bidElapsedTime: \(bidElapsedTime)")
                    
                    // The driver missed responding to the bid
                    AlertUtil.displayAlert("Bid missed.",
                                      message: "Reason: You missed sending the bid. Missing a lot of bids would bring you offline.")
                    
                    return;
                }
                
                // prepare the offerViewController
                let offerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Offer, bundle: nil)

                let offerViewController = offerStoryboard.instantiateViewController(withIdentifier: "OfferViewControllerIdentifier") as! OfferViewController

                let navController = UINavigationController(rootViewController: offerViewController)

                // start the timer by accouting the time elapsed since the user actually created the bid
                offerViewController.timerStart = TimeInterval(Int(OfferViewController.OFFER_TIMER_EXPIRE_PERIOD - bidElapsedTime))
                
                offerViewController.userBid = bid

                DDLogDebug("userBid: \(offerViewController.userBid.toJSONString(prettyPrint: true))")
                
                // if an alert was already displayed, dismiss it
                if let vvc = appDelegate.window!.visibleViewController as? UIAlertController {
                    DDLogDebug("Alert is up \(vvc)")
                    vvc.dismiss(animated: false, completion: nil)
                } else {
                    DDLogDebug("Alert is NOT up \(appDelegate.window!.visibleViewController)")
                }
                
                mmnvc.present(navController, animated: true, completion: nil)

                break

            case OFFER_REJECTED_MESSAGE_TYPE:
                DDLogDebug("REJECT RCVD")
                
                let bid = Bid(JSONString: jsonCustomString)!
                
                // find the DriverOnlineViewController and pop till that
                for viewController: UIViewController in mmnvc.viewControllers {
                    
                    if (viewController is DriverOnlineViewController) {
                        
                        let driverOnlineController: DriverOnlineViewController = (viewController as! DriverOnlineViewController)
                        
                        // dismiss all view controllers till this view controller
                        driverOnlineController.dismiss(animated: true, completion: nil)
                        
                        AlertUtil.displayAlertOnVC(driverOnlineController,
                                                   title: "Offer Rejected.",
                                                   message: "Reason: Your offer was not the lowest.")
                    }
                }
                
                break
                
            case DRIVER_EN_ROUTE_MESSAGE_TYPE:
                
                DDLogDebug("DRIVER EN ROUTE")
                
                let ride = Ride(JSONString: jsonCustomString)!
                
                if (!YBClient.sharedInstance().isSameAsOngoingBid(bidId: ride.bidId)) {
                    DDLogDebug("Not same as ongoingBid. Discarded: \(notification[MESSAGE_JSON_FIELD_NAME] as! String)")
                    
                    if let ongoingBid = YBClient.sharedInstance().getBid() {
                        DDLogDebug("Ongoingbid is: \(String(describing: ongoingBid.id)). Incoming is \(String(describing: ride.bidId))")
                    } else {
                        DDLogDebug("Ongoingbid is: nil. Incoming is \(String(describing: ride.bidId))")
                    }
                    
                    return;
                }
                
                // find the DriverOnlineViewController and pop till that
                for viewController: UIViewController in mmnvc.viewControllers {
                    
                    if (viewController is DriverOnlineViewController) {
                        
                        let driverOnlineController: DriverOnlineViewController = (viewController as! DriverOnlineViewController)
                        
                        // dismiss all view controllers till this view controller
                        DDLogDebug("driverOnlineController dismissed")
                        driverOnlineController.dismiss(animated: true, completion: nil)
                    }
                }
                
                let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
                
                let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
                mmnvc.pushViewController(rideStartViewController, animated: true)

//                let driverEnRouteStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.DriverEnRoute, bundle: nil)
//
//                let driverEnRouteViewController = driverEnRouteStoryboard.instantiateViewController(withIdentifier: "DriverEnRouteViewControllerIdentifier") as! DriverEnRouteViewController
//                mmnvc.pushViewController(driverEnRouteViewController, animated: true)
                
                break
                
            case RIDE_START_MESSAGE_TYPE:
                DDLogDebug("RIDE START MESSAGE RCVD")
                break
                
            case RIDE_CANCELLED_MESSAGE_TYPE:
                DDLogDebug("RIDE CANCELLED MESSAGE RCVD")
                break
                
            default: break
            }
        }
    }
    
    //MARK: APNS Token
    open func didRegisterForRemoteNotificationsWithDeviceToken(_ data:Data) {
        
    }

    //MARK: Utility
    
    open static func registerForPushNotifications() {
        
        let application: UIApplication = UIApplication.shared
        
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
    }
}
