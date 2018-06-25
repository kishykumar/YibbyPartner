//
//  Ride.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/13/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import ObjectMapper

enum RideCancelled: Int {
    case notCancelled = 0
    case cancelledByRider = 1
    case cancelledByDriver = 2
}

class Ride: Mappable {
    
    // MARK: - Properties
    
    var id: String?
    var bidPrice: Float?
    var people: Int?
    var pickupLocation: YBLocation?
    var dropoffLocation: YBLocation?
    var riderLocation: YBLocation?
    var rider: YBRider?
    var bidId: String?
    var datetime: String?
    var tripDistance: Float?
    var tripDuration: Int?
    var tip: Float?
    var otherEarnings: Float?
    var vehicle: YBVehicle?
    var cancelled: Int?

    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id                  <- map["id"]
        bidPrice            <- map["bidPrice"]
        people              <- map["people"]
        pickupLocation      <- map["pickupLocation"]
        dropoffLocation     <- map["dropoffLocation"]
        riderLocation       <- map["riderLocation"]
        rider               <- map["rider"]
        bidId               <- map["bidId"]
        datetime            <- map["datetime"]
        tripDistance        <- map["tripDistance"]
        tripDuration        <- map["tripDuration"]
        tip                 <- map["tip"]
        otherEarnings       <- map["otherEarnings"]
        vehicle             <- map["vehicle"]
        cancelled               <- map["cancelled"]
    }
}
