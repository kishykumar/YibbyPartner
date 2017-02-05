//
//  Offer.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/13/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectMapper

class Offer: Mappable {
    
    // MARK: Properties
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
