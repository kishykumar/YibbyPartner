//
//  YBClient.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import CocoaLumberjack

enum YBClientStatus: String {
    case detailsNotSubmitted = "DETAILS_NOT_SUBMITTED"
    case notApproved = "NOT_APPROVED"
    case offline = "OFFLINE"
    case online = "ONLINE"
    case offerInProcess = "OFFER_IN_PROCESS" // driver is still trying to bid
    case offerSent = "OFFER_SENT" // driver has already bid and seeing the progress screen
    case offerRejected = "OFFER_REJECTED"
    case driverEnRoute = "DRIVER_EN_ROUTE"
    case driverArrived = "DRIVER_ARRIVED"
    case rideStart = "RIDE_START"
    case rideEnd = "RIDE_END"
}

// BidState singleton
open class YBClient {
    
    private static let myInstance = YBClient()
    
    var status: YBClientStatus
    
    var bid: Bid? {
        didSet {
            if (self.bid == nil) {
                removePersistedBidId()
            } else {
                persistBidId()
            }
        }
    }
    
    var ride: Ride?
    var profile: YBProfile?
    var registrationDetails = Registration()
    
    let APP_BID_ID_KEY = "APP_BID_ID"

    var fakeBid: Bid {
        get {
            let bid = Bid()
            bid.bidHigh = 20
            bid.people = 2
            bid.dropoffLocation = YBLocation(lat: 37.787884, long: -122.407536, name: "Union Square, San Francisco")
            bid.pickupLocation = YBLocation(lat: 37.531631, long: -122.263606, name: "420 Oracle Pkwy, Redwood City, CA 94065")
            bid.creationTime = ""
            return bid
        }
    }
    
    var fakeRide: Ride {
        get {
            let ride = Ride()
            ride.riderBidPrice = 40
            ride.driverBidPrice = 40
            ride.tip = 2.0
            ride.totalCharge = 42.0
            ride.fare = 40 // this is the price of ride excluding the tip
            
            ride.bidId = "myid"
            ride.datetime = ""
            ride.id = "myrideid"
            ride.miles = 13.5
            ride.people = 2
            ride.rider = nil
            ride.rideTime = 22
            
            ride.dropoffLocation = YBLocation(lat: 37.787884, long: -122.407536, name: "Union Square, San Francisco")
            ride.pickupLocation = YBLocation(lat: 37.531631, long: -122.263606, name: "420 Oracle Pkwy, Redwood City, CA 94065")
            return ride
        }
    }
    
    init() {
        status = .offline
    }
    
    static func sharedInstance () -> YBClient {
        return myInstance
    }
    
//    func setBid (_ bid: Bid?) { self.bid = bid }
//    func getBid () -> Bid? { return bid }
//    
//    func setRide (_ ride: Ride?) { self.ride = ride }
//    func getRide () -> Ride? { return ride }
//    
//    func setStatus (_ status: YBClientStatus) { self.status = status }
//    func getStatus () -> YBClientStatus? { return status }
    
    func isOngoingBid () -> Bool {
        return (self.bid != nil)
    }
    
    func isSameAsOngoingBid (bidId: String?) -> Bool {
        
        if (self.bid == nil || bidId == nil) {
            return false
        }
        
        return ((self.bid!.id ) == bidId)
    }
    
    fileprivate func persistBidId() {
        let bidId = self.bid?.id
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(bidId, forKey: APP_BID_ID_KEY)
    }
    
    fileprivate func removePersistedBidId() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: APP_BID_ID_KEY)
    }
    
    func getPersistedBidId() -> String? {
        let userDefaults = UserDefaults.standard
        let bidId = userDefaults.object(forKey: APP_BID_ID_KEY) as? String
        return bidId
    }

    func syncClient(_ syncData: YBSync) {
        if let myBid = syncData.bid {
            self.bid = myBid
        }
        
        if let myRide = syncData.ride {
            self.ride = myRide
        }
        
        if let myProfile = syncData.profile {
            self.profile = myProfile
        }
        
        if let status = syncData.status {
            self.status = status
        }
    }
}
