//
//  TimeUtil.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/8/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

open class TimeUtil {
    
    static let shared = TimeUtil()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        return formatter
    }()
    
    static func getISODate(inDate: Date) -> String {
        return formatter.string(from: inDate)
    }
    
    static func getDateFromISOTime (_ isoTime: String) -> Date? {
        return formatter.date(from: isoTime)
    }
    
    static func diffFromCurTimeISO (_ fromIsoTime: String) -> TimeInterval {
        
        let isoNSDate: Date = formatter.date(from: fromIsoTime)!
        
        // Get the current time
        let curTime = Date()
        
        let secondsBetween: TimeInterval = curTime.timeIntervalSince(isoNSDate)
        return secondsBetween
    }
    
    static func diffFromCurTime (_ fromTime: Date) -> TimeInterval {
        
        // Get the current time
        let curTime = Date()
        
        let secondsBetween: TimeInterval = curTime.timeIntervalSince(fromTime)
        return secondsBetween
    }
    
    static func prettyPrintDate1 (_ date: Date) -> String? {
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
