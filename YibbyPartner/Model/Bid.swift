//
//  Bid.swift
//  Yibby
//
//  Created by Kishy Kumar on 3/10/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectMapper

class Bid: Mappable {
    
    // MARK: - Properties
    var id: String?
    var bidHigh: Int?
    
    var pickupLocation: YBLocation?
    var dropoffLocation: YBLocation?
    
    var people: Int?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id         <- map["id"]
        bidHigh    <- map["bidHigh"]
        pickupLocation     <- map["pickupLocation"]
        dropoffLocation     <- map["dropoffLocation"]
        people <- map["people"]
    }
}
