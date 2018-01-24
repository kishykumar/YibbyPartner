//
//  YBProfile.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/4/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import ObjectMapper

class YBProfile: Mappable {
    
    // MARK: - Properties
    var personal: YBPersonal?
    var vehicle: YBVehicle?
    var driverLicense: YBDriverLicense?
    var insurance: YBInsurance?

    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }

    // Mappable
    func mapping(map: Map) {
        personal                <- map["personal"]
        vehicle                 <- map["vehicle"]
        driverLicense           <- map["driverLicense"]
        insurance               <- map["insurance"]
    }
}
