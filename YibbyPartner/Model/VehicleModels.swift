//
//  VehicleModels.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/11/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class VehicleModels: Mappable {
    
    //  JSON object:
    //    [VehicleModel, ...]
    
    // MARK: - Properties
    var models: [VehicleModel]?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        // do the checks here to make sure if a required property exists within the JSON.
    }
    
    // Mappable
    func mapping(map: Map) {
        models <- map["Models"]
    }
}

extension VehicleModels {
    
}
