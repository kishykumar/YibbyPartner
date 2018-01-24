//
//  YBWeekStat.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 11/23/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBWeekStat: Mappable {
    
    // MARK: - Properties
    var startCollectionDate: String?
    var endCollectionDate: String?
    var onlineTime: Int?
    var earning: Double?
    var rides: Int?
    var paidAmount: Double?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        // do the checks here to make sure if a required property exists within the JSON.
    }
    
    // Mappable
    func mapping(map: Map) {
        startCollectionDate <- map["startCollectionDate"]
        endCollectionDate <- map["endCollectionDate"]
        onlineTime <- map["onlineTime"]
        earning <- map["earning"]
        rides <- map["rides"]
        paidAmount <- map["paidAmount"]
    }
}
