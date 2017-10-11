//
//  YBPasswordRule.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/03/17.
//  Copyright © 2017 YibbyPartner. All rights reserved.
//

import Foundation
import SwiftValidator

/**
 `PasswordRule` is a subclass of RegexRule that defines how a password is validated.
 */
public class YBPasswordRule : RegexRule {
    
    // Alternative Regexes
    
    // 8 characters. One uppercase. One Lowercase. One number.
    // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$"
    
    static let regex = "^(?=.*?[!&^%$#@()/_*+-])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$"
    
    // no length. One uppercase. One lowercae. One number.
    // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).*?$"
    
    /// Regular express string to be used in validation.
    // static let regex = "^(?=.*?[A-Z]).{8,}$"
    
    /**
     Initializes a `PasswordRule` object that will validate a field is a valid password.
     
     - parameter message: String of error message.
     - returns: An initialized `PasswordRule` object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public convenience init(message : String = "Minimum 8 characters. 1 uppercase, lowercase, number, special character") {
        self.init(regex: YBPasswordRule.regex, message : message)
    }
}
