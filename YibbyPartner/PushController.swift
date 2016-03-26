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

@objc public protocol PushControllerProtocol {
    func receiveRemoteNotification(notification:[NSObject:AnyObject])
}

public class PushController: NSObject, PushControllerProtocol {
    
    let BID_MESSAGE_TYPE = "BID"
    let RIDE_START_MESSAGE_TYPE = "RIDE_START"
    let DRIVER_EN_ROUTE_MESSAGE_TYPE = "DRIVER_EN_ROUTE"
    let OFFER_REJECTED_MESSAGE_TYPE = "OFFER_REJECTED"
    
    let MESSAGE_FIELD_NAME = "message"
    let CUSTOM_JSON_FIELD_NAME = "custom"
    let BID_JSON_FIELD_NAME = "bid"
    
    public override init() {
        super.init()
    }

    //MARK: Receiving remote notification
    public func receiveRemoteNotification(notification: [NSObject : AnyObject]) {
        print(notification)
        
        // handle bid
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mmdc : MMDrawerController = appDelegate.window?.rootViewController as! MMDrawerController
        
        switch notification[MESSAGE_FIELD_NAME] as! String {
        case BID_MESSAGE_TYPE:
            
            if let mmnvc = mmdc.centerViewController as? UINavigationController {
                // get the storyboard to instantiate the viewcontroller
                let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

                let jsonCustom = notification[CUSTOM_JSON_FIELD_NAME]
                if let data = jsonCustom!.dataUsingEncoding(NSUTF8StringEncoding) {
                    let topJson = JSON(data: data)
                    let topBidJson = topJson[BID_JSON_FIELD_NAME]

                    if let bidData = topBidJson.stringValue.dataUsingEncoding(NSUTF8StringEncoding) {
                        let bidJson = JSON(data: bidData)
                        
                        // prepare the offerViewController
                        let offerViewController = mainstoryboard.instantiateViewControllerWithIdentifier("OfferViewControllerIdentifier") as! OfferViewController
                        
                        offerViewController.userBid = Bid(id: bidJson["id"].stringValue, bidHigh: bidJson["bidHigh"].intValue, bidLow: bidJson["bidLow"].intValue,
                            etaHigh: bidJson["etaHigh"].intValue, etaLow: bidJson["etaLow"].intValue, pickupLat: bidJson["pickupLat"].doubleValue,
                            pickupLong: bidJson["pickupLong"].doubleValue, pickupLoc: bidJson["pickupLoc"].stringValue, dropoffLat: bidJson["dropoffLat"].doubleValue,
                            dropoffLong: bidJson["dropoffLong"].doubleValue, dropoffLoc: bidJson["dropoffLoc"].stringValue)
                    
                        mmnvc.pushViewController(offerViewController, animated: true)
                    }
                }
            }
        case OFFER_REJECTED_MESSAGE_TYPE: break
        case DRIVER_EN_ROUTE_MESSAGE_TYPE: break
        case RIDE_START_MESSAGE_TYPE: break
        default: break
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