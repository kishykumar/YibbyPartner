//
//  LogFormatter.swift
//  Yibby
//
//  Created by Kishy Kumar on 5/5/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LogFormatter: NSObject, DDLogFormatter {
    let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        //        dateFormatter.formatterBehavior = .Behavior10_4
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        super.init()
    }
    
    func format(message logMessage: DDLogMessage) -> String? {
        let dateAndTime = dateFormatter.string(from: logMessage.timestamp)
        return "\(dateAndTime) [\(logMessage.fileName):\(String(describing: logMessage.function)):\(logMessage.line)]: \(logMessage.message)"
        //        return "\(logMessage.timestamp) [\(logMessage.fileName):\(logMessage.line)]: \(logMessage.message)"
    }
}
