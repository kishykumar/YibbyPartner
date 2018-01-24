//
//  YBDriverStats.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 11/23/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class YBDriverStats: Mappable {
    
    // MARK: - Properties
    var week: YBWeekStat?
    var daily: [YBDayStat]?
    
    // MARK: Initialization
    
    required init?(map: Map) {
        // do the checks here to make sure if a required property exists within the JSON.
    }
    
    // Mappable
    func mapping(map: Map) {
        week <- map["week"]
        daily <- map["daily"]
    }
}
