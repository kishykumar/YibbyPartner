//
//  Bid.swift
//  Yibby
//
//  Created by Kishy Kumar on 3/10/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import ObjectMapper

class Bid: Mappable {
    
    // MARK: - Properties
    var id: String?
    var bidPrice: Double?
    var pickupLocation: YBLocation?
    var dropoffLocation: YBLocation?
    var people: Int?
    var creationTime: String?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id                  <- map["id"]
        bidPrice             <- map["bidPrice"]
        pickupLocation      <- map["pickupLocation"]
        dropoffLocation     <- map["dropoffLocation"]
        people              <- map["people"]
        creationTime        <- map["creationTime"]
    }
}
