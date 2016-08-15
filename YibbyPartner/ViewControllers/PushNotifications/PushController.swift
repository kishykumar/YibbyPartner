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
    func receiveRemoteNotification(application: UIApplication, notification:[NSObject:AnyObject])
}

public class PushController: NSObject, PushControllerProtocol {
    
    let BID_MESSAGE_TYPE = "BID"
    let RIDE_START_MESSAGE_TYPE = "RIDE_START"
    let DRIVER_EN_ROUTE_MESSAGE_TYPE = "DRIVER_EN_ROUTE"
    let OFFER_REJECTED_MESSAGE_TYPE = "OFFER_REJECTED"
    
    let MESSAGE_JSON_FIELD_NAME = "message"
    let CUSTOM_JSON_FIELD_NAME = "custom"
    let BID_JSON_FIELD_NAME = "bid"
    let RIDE_JSON_FIELD_NAME = "ride"
    let ID_JSON_FIELD_NAME = "id"
    let BID_ID_JSON_FIELD_NAME = "bidId"
    let GCM_MSG_ID_JSON_FIELD_NAME = "gcm.message_id"
    
    var savedNotification: [NSObject : AnyObject]?
    
    let BID_NOTIFICATION_EXPIRE_TIME: NSTimeInterval = 30 // seconds
    
    var mLastGCMMsgId: String?
    
    public override init() {
        super.init()
    }

    //MARK: Receiving remote notification
    public func receiveRemoteNotification(application: UIApplication, notification: [NSObject : AnyObject]) {
        
// TODO: Add this code
//        if (DRIVER IS OFFLINE) {
//          return;
//        }
    
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if (!appDelegate.initialized) {
            return;
        }
        
        if application.applicationState == .Background {
            //opened from a push notification when the app was on background
            DDLogDebug("App in BG")
            handleBgNotification(notification)
        }
        else if (application.applicationState == .Inactive) {
            // ignore the BID message
            DDLogDebug ("App in inactive state")
            handleBgNotification(notification)
        }
        else { // App in foreground
            DDLogDebug("App in FG")
            handleFgNotification(notification)
        }
    }

    func handleBgNotification (notification: [NSObject : AnyObject]) {
        
        // save the most recent push message
        DDLogDebug("Save push message in BG from \(savedNotification) to \(notification)")
        
        savedNotification = [NSObject : AnyObject]()
        savedNotification = notification
    }
    
    func handleFgNotification (notification: [NSObject : AnyObject]) {
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
    
    func processNotification (notification: [NSObject : AnyObject]) {
        
        DDLogVerbose("Called")
        
        // handle bid
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if notification[MESSAGE_JSON_FIELD_NAME] == nil {
            DDLogDebug("No notification message found")
            return;
        }
        
        // check if we have already processed this push message
        let lastGCMMsgId: String = notification[GCM_MSG_ID_JSON_FIELD_NAME] as! String
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
            if let data = jsonCustom!.dataUsingEncoding(NSUTF8StringEncoding) {
                let topJson = JSON(data: data)
                if let topBidJson = topJson[BID_JSON_FIELD_NAME].string {
                
                    if let bidData = topBidJson.dataUsingEncoding(NSUTF8StringEncoding) {
                        let bidJson = JSON(data: bidData)
                        
                        switch notification[MESSAGE_JSON_FIELD_NAME] as! String {
                        case BID_MESSAGE_TYPE:
                            DDLogDebug("BID message RCVD")

                            let bidElapsedTime = TimeUtil.diffFromCurTimeISO(bidJson["_creation_date"].stringValue)
                            if (bidElapsedTime > BID_NOTIFICATION_EXPIRE_TIME) {
                                DDLogDebug("Bid Discarded CurrentTime: \(NSDate()) bidTime: \(bidJson["_creation_date"].stringValue) bidElapsedTime: \(bidElapsedTime)")
                                
                                // The driver missed responding to the bid
                                AlertUtil.displayAlert("Bid missed.",
                                                  message: "Reason: You missed sending the bid. Missing a lot of bids would bring you offline.")
                                
                                return;
                            }
                            
                            // prepare the offerViewController
                            let navController: UINavigationController = UINavigationController()

                            let offerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Offer, bundle: nil)

                            let offerViewController = offerStoryboard.instantiateViewControllerWithIdentifier("OfferViewControllerIdentifier") as! OfferViewController

                            navController.pushViewController(offerViewController, animated: false)

                            // start the timer by accouting the time elapsed since the user actually created the bid
                            offerViewController.timerStart = NSTimeInterval(Int(OfferViewController.OFFER_TIMER_EXPIRE_PERIOD - bidElapsedTime))
                            
                            offerViewController.userBid = Bid(id: bidJson["id"].stringValue,
                                                              bidHigh: bidJson["bidHigh"].intValue,
                                                              bidLow: bidJson["bidLow"].intValue,
                                                              etaHigh: bidJson["etaHigh"].intValue,
                                                              etaLow: bidJson["etaLow"].intValue,
                                                              pickupLat: bidJson["pickupLat"].doubleValue,
                                                              pickupLong: bidJson["pickupLong"].doubleValue,
                                                              pickupLoc: bidJson["pickupLoc"].stringValue,
                                                              dropoffLat: bidJson["dropoffLat"].doubleValue,
                                                              dropoffLong: bidJson["dropoffLong"].doubleValue,
                                                              dropoffLoc: bidJson["dropoffLoc"].stringValue)
                            
                            DDLogDebug("userBid: \(offerViewController.userBid)")
                            
                            // if an alert was already displayed, dismiss it
                            if let vvc = appDelegate.window!.visibleViewController as? UIAlertController {
                                DDLogDebug("Alert is up \(vvc)")
                                vvc.dismissViewControllerAnimated(false, completion: nil)
                            } else {
                                DDLogDebug("Alert is NOT up \(appDelegate.window!.visibleViewController)")
                            }
                            
                            mmnvc.presentViewController(navController, animated: true, completion: nil)

                            break

                        case OFFER_REJECTED_MESSAGE_TYPE:
                            DDLogDebug("REJECT RCVD")
                            
                            // find the DriverOnlineViewController and pop till that
                            for viewController: UIViewController in mmnvc.viewControllers {
                                
                                if (viewController is DriverOnlineViewController) {
                                    
                                    let driverOnlineController: DriverOnlineViewController = (viewController as! DriverOnlineViewController)
                                    
                                    // dismiss all view controllers till this view controller
                                    driverOnlineController.dismissViewControllerAnimated(true, completion: nil)
                                    
                                    AlertUtil.displayAlertOnVC(driverOnlineController,
                                                               title: "Offer Rejected.",
                                                               message: "Reason: Your offer was not the lowest.")
                                }
                            }
                            
                            break
                            
                        default: break
                        }
                    }
                }
                else if let topRideJson = topJson[RIDE_JSON_FIELD_NAME].string {
                    if let rideData = topRideJson.dataUsingEncoding(NSUTF8StringEncoding) {
                        let rideJson = JSON(data: rideData)
                        
                        switch notification[MESSAGE_JSON_FIELD_NAME] as! String {

                        case DRIVER_EN_ROUTE_MESSAGE_TYPE:
                            
                            DDLogDebug("DRIVER EN ROUTE")
                            
                            if (!BidState.sharedInstance().isSameAsOngoingBid(rideJson[BID_ID_JSON_FIELD_NAME].string)) {
                                DDLogDebug("Not same as ongoingBid. Discarded: \(notification[MESSAGE_JSON_FIELD_NAME] as! String)")
                                
                                if let ongoingBid = BidState.sharedInstance().getOngoingBid() {
                                    DDLogDebug("Ongoingbid is: \(ongoingBid.id). Incoming is \(rideJson[BID_ID_JSON_FIELD_NAME].string)")
                                } else {
                                    DDLogDebug("Ongoingbid is: nil. Incoming is \(rideJson[BID_ID_JSON_FIELD_NAME].string)")
                                }
                                
                                return;
                            }
                            
                            // find the DriverOnlineViewController and pop till that
                            for viewController: UIViewController in mmnvc.viewControllers {
                                
                                if (viewController is DriverOnlineViewController) {
                                    
                                    let driverOnlineController: DriverOnlineViewController = (viewController as! DriverOnlineViewController)
                                    
                                    // dismiss all view controllers till this view controller
                                    DDLogDebug("driverOnlineController dismissed")
                                    driverOnlineController.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                            
                            let driverEnRouteStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.DriverEnRoute, bundle: nil)

                            let driverEnRouteViewController = driverEnRouteStoryboard.instantiateViewControllerWithIdentifier("DriverEnRouteViewControllerIdentifier") as! DriverEnRouteViewController
                            DDLogDebug("driverEnRouteViewController shown")
                            mmnvc.pushViewController(driverEnRouteViewController, animated: true)
                            
                            break
                            
                        case RIDE_START_MESSAGE_TYPE:
                            DDLogDebug("RIDE START MESSAGE RCVD")
                            break
                            
                        default: break
                        }
                    }

                }
            }
        }
    }
    
    //MARK: APNS Token
    public func didRegisterForRemoteNotificationsWithDeviceToken(data:NSData) {
        
    }

    //MARK: Utility
    
    public static func registerForPushNotifications() {
        
        let application: UIApplication = UIApplication.sharedApplication()
        
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
    }
}