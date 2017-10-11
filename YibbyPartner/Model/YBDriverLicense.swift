//
//  DriverLicense.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBDriverLicense: Mappable {
    
    //  JSON object:
    //		  "driverLicense": {
    //		    "firstName":"object",
    //		    "lastName":"object",
    //		    "middleName":"object",
    //		    "number": "object",
    //		    "state": "object",
    //		    "dob":"object",
    //			"expiration": "date",
    //		    "licensePicture": "fileID"
    //		  }
    
    // MARK: - Properties
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var number: String?
    var state: String?
    var dob: String?
    var expiration: String?
    var licensePicture: String?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        firstName         <- map["firstName"]
        lastName         <- map["lastName"]
        middleName     <- map["middleName"]
        number <- map["number"]
        state <- map["state"]
        dob <- map["dob"]
        expiration          <- map["expiration"]
        licensePicture         <- map["licensePicture"]
    }
}
