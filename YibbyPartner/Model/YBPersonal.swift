//
//  PersonalDetails.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBPersonal: Mappable {
    
    //  JSON object:
    //		  "personal": {
    //		    "ssn":"string",
    //		    "dob":"string",
    //		    "emailId":"string",
    //		    "phoneNumber": "string",
    //		    "streetAddress": "string",
    //		    "city": "string",
    //		    "state": "string",
    //		    "country": "string",
    //		    "profilePicture":"string"
    //		  }
    
    // MARK: - Properties
    var ssn: String?
    var dob: String?
    var emailId: String?
    var phoneNumber: String?
    var streetAddress: String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var profilePicture: String?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        ssn         <- map["ssn"]
        dob         <- map["dob"]
        emailId     <- map["emailId"]
        phoneNumber <- map["phoneNumber"]
        streetAddress <- map["streetAddress"]
        city          <- map["city"]
        state         <- map["state"]
        country       <- map["country"]
        postalCode    <- map["postalCode"]
        profilePicture <- map["profilePicture"]
    }
}
