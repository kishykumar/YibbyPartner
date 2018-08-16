//
//  YBNotifications.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/27/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import Foundation

public struct BidNotifications {
    static let bidReceived = TypedNotification<Bid>(name: "com.Yibby.Bid.BidReceived")
    static let bidEnded = TypedNotification<Bid>(name: "com.Yibby.Bid.bidEnded")
}

public struct RideNotifications {
    static let rideCancelled = TypedNotification<Ride>(name: "com.Yibby.Ride.RideCancelled")
}
