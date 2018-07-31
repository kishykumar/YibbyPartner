//
//  UserDefaults.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 7/30/18.
//  Copyright © 2018 MyComp. All rights reserved.
//

import Foundation

open class Defaults{
    
    static let defaults = UserDefaults.standard
    
    static func setDefaultMap(value:Int){
        defaults.set(value, forKey: "mapForNav")
    }
    
    static func getDefaultMap() -> Int{
        return defaults.integer(forKey: "mapForNav")
    }
}

