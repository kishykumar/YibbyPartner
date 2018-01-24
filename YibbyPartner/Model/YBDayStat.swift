//
//  YBDayStat.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 11/23/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBDayStat: Mappable {
    
    // MARK: - Properties
    var collectionDate: String?
    var onlineTime: Int?
    var earning: Double?
    var rides: Int?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        // do the checks here to make sure if a required property exists within the JSON.
    }
    
    // Mappable
    func mapping(map: Map) {
        collectionDate <- map["collectionDate"]
        onlineTime <- map["onlineTime"]
        earning <- map["earning"]
        rides <- map["rides"]
    }
}
