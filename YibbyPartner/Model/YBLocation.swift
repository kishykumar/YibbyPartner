//
//  YBLocation.swift
//  Yibby
//
//  Created by Kishy Kumar on 1/4/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectMapper

class YBLocation: NSObject {
    
    // MARK: - Properties
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var name: String?
    
    var streetAddress: String?
    var region: String?
    var city: String?
    
    var country: String?
    var streetName: String?
    var streetNumber: String?
    var postalCode: String?
    var course: Int?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        latitude        <- map["latitude"]
        longitude       <- map["longitude"]
        name            <- map["name"]
    }
    
    init(lat: CLLocationDegrees,
         long: CLLocationDegrees) {
        
        // Initialize stored properties.
        self.latitude = lat
        self.longitude = long
    }
    
    init(coordinate: CLLocationCoordinate2D,
         name: String) {
        
        // Initialize stored properties.
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.name = name
    }
    
    init(lat: CLLocationDegrees,
         long: CLLocationDegrees,
         name: String) {
        
        // Initialize stored properties.
        self.latitude = lat
        self.longitude = long
        self.name = name
    }
}

extension YBLocation {
    
    func coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
    }
}
