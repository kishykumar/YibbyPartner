//
//  LogFormatter.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 5/5/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import Foundation
import CocoaLumberjack.DDDispatchQueueLogFormatter

class LogFormatter: DDDispatchQueueLogFormatter {
    let dateFormatter: NSDateFormatter
    
    override init() {
        dateFormatter = NSDateFormatter()
//        dateFormatter.formatterBehavior = .Behavior10_4
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        super.init()
    }
    
    override func formatLogMessage(logMessage: DDLogMessage!) -> String {
        let dateAndTime = dateFormatter.stringFromDate(logMessage.timestamp)
        return "\(dateAndTime) [\(logMessage.fileName):\(logMessage.function):\(logMessage.line)]: \(logMessage.message)"
//        return "\(logMessage.timestamp) [\(logMessage.fileName):\(logMessage.line)]: \(logMessage.message)"
    }
}