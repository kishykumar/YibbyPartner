//
//  YBFunding.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/9/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBFunding: Mappable {
    
    //  JSON object:
    //            "funding": {
    //              "accountNumber": "1234567890",
    //              "routingNumber": "1234567890"
    //            }
    
    // MARK: - Properties
    var accountNumber: String?
    var routingNumber: String?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        accountNumber         <- map["accountNumber"]
        routingNumber         <- map["routingNumber"]
    }
}
