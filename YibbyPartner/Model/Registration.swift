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
    var driving: YBDriving = YBDriving()
    var personal: YBPersonal = YBPersonal()
    var vehicle: YBVehicle = YBVehicle()
    var driverLicense: YBDriverLicense = YBDriverLicense()
    var insurance: YBInsurance = YBInsurance()
    var funding: YBFunding = YBFunding()
    
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
        funding <- map["funding"]
    }
}
