//
//  VehicleMake.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/11/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class VehicleMake: Mappable {

//  JSON object:
//    {
//    "make_id": "acura",
//    "make_display": "Acura",
//    "make_is_common": "1",
//    "make_country": "USA"
//    }
    
    // MARK: - Properties
    var makeId: String?
    var makeDisplay: String?
    var makeIsCommon: String?
    var makeCountry: String?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        makeId              <- map["make_id"]
        makeDisplay         <- map["make_display"]
        makeIsCommon        <- map["make_is_common"]
        makeCountry         <- map["make_country"]
    }
}

extension VehicleMake {

}
