//
//  InsuranceDetails.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBInsurance: Mappable {
    
    //  JSON object:
    //		  "insurance": {
    //		    "insuranceExpiration": "date",
    //		    "insuranceState": "state",
    //		    "insuranceCardPicture": "fileID"
    //		  }
    
    // MARK: - Properties
    var insuranceExpiration: String?
    var insuranceState: String?
    var insuranceCardPicture: String?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        insuranceExpiration         <- map["insuranceExpiration"]
        insuranceState         <- map["insuranceState"]
        insuranceCardPicture     <- map["insuranceCardPicture"]
    }
}
