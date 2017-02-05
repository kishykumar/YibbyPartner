//
//  TemporaryCache.swift
//  Ello
//
//  Created by Colin Gray on 6/1/2015.
//  Copyright (c) 2015 Ello. All rights reserved.
//

typealias TemporaryCacheEntry = (image: UIImage, expiration: Date)
public enum CacheKey {
    case coverImage
    case profilePicture
    case insurancePicture
    case licensePicture
    case vehicleInspectionPicture
}
public struct TemporaryCache {
    static var coverImage: TemporaryCacheEntry?
    static var profilePicture: TemporaryCacheEntry?
    static var insurancePicture: TemporaryCacheEntry?
    static var licensePicture: TemporaryCacheEntry?
    static var vehicleInspectionPicture: TemporaryCacheEntry?
    
    static func save(_ key: CacheKey, image: UIImage) {
        let fiveMinutes: TimeInterval = 5 * 60
        let date = Date(timeIntervalSinceNow: fiveMinutes)
        switch key {
        case .coverImage:
            TemporaryCache.coverImage = (image: image, expiration: date)
        case .insurancePicture:
            TemporaryCache.insurancePicture = (image: image, expiration: date)
        case .licensePicture:
            TemporaryCache.licensePicture = (image: image, expiration: date)
        case .vehicleInspectionPicture:
            TemporaryCache.vehicleInspectionPicture = (image: image, expiration: date)
        case .profilePicture:
            TemporaryCache.profilePicture = (image: image, expiration: date)
        }
    }
    
    static func load(_ key: CacheKey) -> UIImage? {
        let date = Date()
        let entry: TemporaryCacheEntry?
        
        switch key {
        case .coverImage:
            entry = TemporaryCache.coverImage
        case .insurancePicture:
            entry = TemporaryCache.insurancePicture
        case .licensePicture:
            entry = TemporaryCache.licensePicture
        case .vehicleInspectionPicture:
            entry = TemporaryCache.vehicleInspectionPicture
        case .profilePicture:
            entry = TemporaryCache.profilePicture
        }
        
        if let entry = entry, (entry.expiration as NSDate).earlierDate(date) == date {
            return entry.image
        }
        return nil
    }
}
