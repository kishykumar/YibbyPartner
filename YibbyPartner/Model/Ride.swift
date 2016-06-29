//
//  Ride.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/13/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps

class Ride: NSObject, NSCopying {
    
    // MARK: Properties
    var id: String
    var bidHigh: Int
    var bidLow: Int
    
    var etaHigh: Int
    var etaLow: Int
    
    var pickupLat: CLLocationDegrees
    var pickupLong: CLLocationDegrees
    var pickupLoc: String
    
    var dropoffLat: CLLocationDegrees
    var dropoffLong: CLLocationDegrees
    var dropoffLoc: String
    
    // MARK: Initialization
    
    init?(id: String, bidHigh: Int, bidLow: Int, etaHigh: Int, etaLow: Int, pickupLat: Double, pickupLong: Double, pickupLoc: String, dropoffLat: Double, dropoffLong: Double, dropoffLoc: String) {
        // Initialize stored properties.
        self.id = id
        self.bidHigh = bidHigh
        self.bidLow = bidLow
        self.etaHigh = etaHigh
        self.etaLow = etaLow
        self.pickupLat = pickupLat
        self.pickupLong = pickupLong
        self.pickupLoc = pickupLoc
        self.dropoffLat = dropoffLat
        self.dropoffLong = dropoffLong
        self.dropoffLoc = dropoffLoc
        
        // Initialization should fail if there is no name or if the rating is negative.
        //        if pickupLoc.isEmpty || dropoffLoc.isEmpty || bidHigh == 0 {
        //            return nil
        //        }
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Bid(id: id, bidHigh: bidHigh, bidLow: bidLow,
                       etaHigh: etaHigh, etaLow: etaLow, pickupLat: pickupLat,
                       pickupLong: pickupLong, pickupLoc: pickupLoc, dropoffLat: dropoffLat,
                       dropoffLong: dropoffLong, dropoffLoc: dropoffLoc)
        
        return copy!
    }
}