//
//  VehicleMakes.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/11/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class VehicleMakes: Mappable {
    
    //  JSON object:
    //    [{
    //    "make_id": "acura",
    //    "make_display": "Acura",
    //    "make_is_common": "1",
    //    "make_country": "USA"
    //    }, ...]
    
    // MARK: - Properties
    var makes: [VehicleMake]?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        // do the checks here to make sure if a required property exists within the JSON.
    }
    
    // Mappable
    func mapping(map: Map) {
        makes <- map["Makes"]
    }
}

extension VehicleMakes {
    
}
