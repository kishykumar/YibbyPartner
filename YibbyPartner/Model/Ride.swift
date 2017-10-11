//
//  Ride.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/13/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import ObjectMapper

class Ride: Mappable {
    
    // MARK: - Properties
    
    var id: String?
    var riderBidPrice: Float?
    var driverBidPrice: Float?
    var fare: Float?
    var people: Int?
    var pickupLocation: YBLocation?
    var dropoffLocation: YBLocation?
    var riderLocation: YBLocation?
    var rider: YBRider?
    var bidId: String?
    var datetime: String?
    var miles: Float?
    var rideTime: Int?
    var tip: Float?
    var totalCharge: Float?
    var vehicle: YBVehicle?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id                  <- map["id"]
        riderBidPrice       <- map["riderBidPrice"]
        driverBidPrice      <- map["driverBidPrice"]
        fare                <- map["fare"]
        people              <- map["people"]
        pickupLocation      <- map["pickupLocation"]
        dropoffLocation     <- map["dropoffLocation"]
        riderLocation       <- map["riderLocation"]
        rider               <- map["rider"]
        bidId               <- map["bidId"]
        datetime            <- map["datetime"]
        miles            <- map["miles"]
        rideTime            <- map["rideTime"]
        tip            <- map["tip"]
        totalCharge            <- map["totalCharge"]
        vehicle                 <- map["vehicle"]
    }
}
