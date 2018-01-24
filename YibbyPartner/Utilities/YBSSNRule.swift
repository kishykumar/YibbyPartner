//
//  YBSSNRule.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/10/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

import Foundation
import SwiftValidator

class SSNRule: RegexRule {
    
    static let regex = "^\\d{3}-\\d{2}-\\d{4}$"
    
    convenience init(message : String = "Not a valid SSN"){
        self.init(regex: SSNRule.regex, message : message)
    }
}
