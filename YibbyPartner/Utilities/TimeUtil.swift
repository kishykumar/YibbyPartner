//
//  TimeUtil.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/8/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

public class TimeUtil {
    
    static func diffFromCurTimeISO (fromIsoTime: String) -> NSTimeInterval {
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        
        let isoNSDate: NSDate = formatter.dateFromString(fromIsoTime)!
        
        // Get the current time
        let curTime = NSDate()
        
        let secondsBetween: NSTimeInterval = curTime.timeIntervalSinceDate(isoNSDate)
        return secondsBetween
    }
    
    static func diffFromCurTime (fromTime: NSDate) -> NSTimeInterval {
        
        // Get the current time
        let curTime = NSDate()
        
        let secondsBetween: NSTimeInterval = curTime.timeIntervalSinceDate(fromTime)
        return secondsBetween
    }
}