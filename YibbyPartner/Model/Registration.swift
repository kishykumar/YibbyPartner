//
//  Registration.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class Registration: Mappable {
    
    // MARK: - Properties
    var driving: DrivingDetails = DrivingDetails()
    var personal: PersonalDetails = PersonalDetails()
    var vehicle: VehicleDetails = VehicleDetails()
    var driverLicense: DriverLicense = DriverLicense()
    var insurance: InsuranceDetails = InsuranceDetails()
    
    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        // do the checks here to make sure if a required property exists within the JSON.
    }
    
    // Mappable
    func mapping(map: Map) {
        driving <- map["driving"]
        personal <- map["personal"]
        vehicle <- map["vehicle"]
        driverLicense <- map["driverLicense"]
        insurance <- map["insurance"]
    }
}
