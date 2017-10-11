//
//  YBNotifications.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/27/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import Foundation

public struct BidNotifications {
    static let bidReceived = TypedNotification<Bid>(name: "com.Yibby.Bid.BidReceived")
    static let offerRejected = TypedNotification<Bid>(name: "com.Yibby.Bid.OfferRejected")
}

public struct RideNotifications {
    static let driverEnRoute = TypedNotification<Ride>(name: "com.Yibby.Ride.DriverEnRoute")
}
