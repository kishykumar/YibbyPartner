//
//  DrivingDetails.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBDriving: Mappable {
    
    //  JSON object:
    //		  "driving": {
    //		    "hasCommercialLicense": true
    //		  }
    
    // MARK: - Properties
    var hasCommercialLicense: Bool?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        hasCommercialLicense <- map["hasCommercialLicense"]
    }
}
