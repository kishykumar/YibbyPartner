//
//  UserDefaults.swift
//  YibbyPartner
//
//  Created by Prabhdeep Singh on 7/30/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

import Foundation

open class Defaults{
    
    static let defaults = UserDefaults.standard
    static let MAP_FOR_NAVIGATION_STRING = "mapForNav"
    
    static func setDefaultNavigationMap(value:Int){
        defaults.set(value, forKey: MAP_FOR_NAVIGATION_STRING)
    }
    
    static func getDefaultNavigationMap() -> Int{
        return defaults.integer(forKey: MAP_FOR_NAVIGATION_STRING)
    }
}

