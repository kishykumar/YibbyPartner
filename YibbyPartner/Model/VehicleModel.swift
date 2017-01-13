//
//  VehicleModel.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/11/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class VehicleModel: Mappable {
    
    //  JSON object:
//    {
//    "model_name": "Crown Victoria",
//    "model_make_id": "ford"
//    }
    
    // MARK: - Properties
    var modelName: String?
    var modelMakeId: String?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        modelName           <- map["model_name"]
        modelMakeId         <- map["model_make_id"]
    }
}

extension VehicleModel {
    
}
