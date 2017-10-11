//
//  YBSync.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/8/17.
//  Copyright © 2017 YibbyPartner. All rights reserved.
//

import UIKit
import ObjectMapper

class YBSync: Mappable {
    
    // MARK: - Properties
    var status: YBClientStatus?
    var profile: YBProfile?
    var bid: Bid?
    var ride: Ride?
    var offer: Offer?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        bid             <- map["bid"]
        status          <- map["status"]
        ride            <- map["ride"]
        offer            <- map["offer"]
        profile         <- map["profile"]
    }
}
