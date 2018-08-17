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
import UserNotifications

@objc public protocol PushControllerProtocol {
    func receiveRemoteNotification(_ application: UIApplication, notification:[AnyHashable: Any])
}

enum YBMessageType: String {
    case bid = "BID"
    case bidEnded = "BID_ENDED"
    case rideCancelled = "RIDE_CANCELLED"
}

open class PushController: NSObject, PushControllerProtocol, UNUserNotificationCenterDelegate {
    
    let MESSAGE_JSON_FIELD_NAME: String = "message"
    let CUSTOM_JSON_FIELD_NAME: String = "custom"
    let BID_JSON_FIELD_NAME: String = "bid"
    let RIDE_JSON_FIELD_NAME: String = "ride"
    let ID_JSON_FIELD_NAME: String = "id"
    let BID_ID_JSON_FIELD_NAME: String = "bidId"
    let GCM_MSG_ID_JSON_FIELD_NAME: String = "gcm.message_id"
    
    var savedNotification: [AnyHashable: Any]?
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
        DDLogDebug("Save push message in BG from \(String(describing: savedNotification)) to \(notification)")
        
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
        
//        // check if we have already processed this push message
//        guard let lastGCMMsgId = notification[GCM_MSG_ID_JSON_FIELD_NAME] as? String else {
//            DDLogDebug("Exiting because lastGCMMsgId is nil: \(notification)")
//            return;
//        }
//
//        if (mLastGCMMsgId != nil) && (mLastGCMMsgId == lastGCMMsgId) {
//            DDLogDebug("Already processed the push message: \(notification)")
//            return;
//        }
//        
//        mLastGCMMsgId = notification[GCM_MSG_ID_JSON_FIELD_NAME] as? String
        
        if (appDelegate.centerContainer == nil) {
            // this might happen during startup
            DDLogDebug("Discarded the notification because centerContainer nil")
            return;
        }
        
        let jsonCustom = notification[CUSTOM_JSON_FIELD_NAME]
        
        guard let jsonCustomString = jsonCustom as? String else {
            DDLogVerbose("Returning because of JSON custom string: \(String(describing: jsonCustom))")
            return;
        }
        
        let messageTypeStr = (notification[MESSAGE_JSON_FIELD_NAME] as! String)
        let messageType: YBMessageType = YBMessageType(rawValue: messageTypeStr)!

        if (messageType == YBMessageType.bid) {
            
            DDLogVerbose("BID message RCVD")
            
            let bid = Bid(JSONString: jsonCustomString)!

            if (YBClient.sharedInstance().isOngoingBid()) {
                DDLogDebug("Ongoing bid. Discarded: \(notification[MESSAGE_JSON_FIELD_NAME] as! String)")
                
                if let ongoingBid = YBClient.sharedInstance().bid {
                    DDLogDebug("Ongoingbid is: \(String(describing: ongoingBid.id)). Incoming is \(String(describing: bid.id))")
                } else {
                    DDLogDebug("Ongoingbid is: nil. Incoming is \(String(describing: bid.id))")
                }
                return;
            }
            
            postNotification(BidNotifications.bidReceived, value: bid)

        } else if (messageType == YBMessageType.bidEnded) {
            
            DDLogDebug("BID_ENDED_MESSAGE_TYPE")
            let bidEndModel = Bid(JSONString: jsonCustomString)!
            
            if (!YBClient.sharedInstance().isSameAsOngoingBid(bidId: bidEndModel.id)) {
                DDLogDebug("Ongoing bid. Discarded: \(notification[MESSAGE_JSON_FIELD_NAME] as! String)")
                
                if let ongoingBid = YBClient.sharedInstance().bid {
                    DDLogDebug("Ongoingbid is: \(String(describing: ongoingBid.id)). Incoming is \(String(describing: bidEndModel.id))")
                } else {
                    DDLogDebug("Ongoingbid is: nil. Incoming is \(String(describing: bidEndModel.id))")
                }
                return;
            }
            
            postNotification(BidNotifications.bidEnded, value: bidEndModel)
            
        } else if (messageType == YBMessageType.rideCancelled) {
            DDLogDebug("RIDE_CANCELLED_MESSAGE_TYPE")
            let ride = Ride(JSONString: jsonCustomString)!
            
            if (!YBClient.sharedInstance().isSameAsOngoingBid(bidId: ride.bidId)) {
                DDLogDebug("Ongoing bid. Discarded: \(notification[MESSAGE_JSON_FIELD_NAME] as! String)")
                
                if let ongoingBid = YBClient.sharedInstance().bid {
                    DDLogDebug("Ongoingbid is: \(String(describing: ongoingBid.id)). Incoming is \(String(describing: ride.bidId))")
                } else {
                    DDLogDebug("Ongoingbid is: nil. Incoming is \(String(describing: ride.bidId))")
                }
                return;
            }
            
            postNotification(RideNotifications.rideCancelled, value: ride)
        }
    }

    //MARK: Utility
    
    open static func registerForPushNotifications() {
        let application: UIApplication = UIApplication.shared
        let appDelegate: UIApplicationDelegate = UIApplication.shared.delegate  as! AppDelegate
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = appDelegate as? UNUserNotificationCenterDelegate
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (bool, error) in
                if let error = error{
                    DDLogVerbose("Error in authorization \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // Fallback
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
}
