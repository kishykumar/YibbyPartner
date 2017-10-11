//
//  VehicleDetails.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/16/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBVehicle: Mappable {
    
    //  JSON object:
    //    vehicle: {
    //		    "exteriorColor":"object",
    //		    "licensePlate":"object",
    //		    "capacity": 4,
    //		    "year": 2016,
    //		    "make":"object",
    //		    "model":"object",
    //		    "inspectionFormPicture": "fileID"
    //		  }

    // MARK: - Properties
    var exteriorColor: String?
    var licensePlate: String?
    var capacity: Int?
    var year: Int?
    var make: String?
    var model: String?
    var inspectionFormPicture: String?
    var vehiclePictureFileId: String?

    // MARK: Initialization
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        exteriorColor         <- map["exteriorColor"]
        licensePlate         <- map["licensePlate"]
        capacity     <- map["capacity"]
        year <- map["year"]
        make <- map["make"]
        model          <- map["model"]
        inspectionFormPicture         <- map["inspectionFormPicture"]
        vehiclePictureFileId <- map["vehiclePictureFileId"]
    }
}
