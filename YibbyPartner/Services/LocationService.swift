//
//  LocationService.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/9/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import BaasBoxSDK
import CocoaLumberjack

// LocationService singleton
open class LocationService: NSObject, CLLocationManagerDelegate {
    
    fileprivate static let myInstance = LocationService()
    fileprivate var locationManager:CLLocationManager!
    
    fileprivate var lastLocUpdateTS = 0.0
    fileprivate var curLocation: CLLocation!

    fileprivate let UPDATES_AGE_TIME: TimeInterval = 120
    fileprivate let DESIRED_HORIZONTAL_ACCURACY = 200.0
    fileprivate let LOCATION_UPDATE_TIME_INTERVAL = 4.0 // seconds

    override init() {
        
    }

    static func sharedInstance () -> LocationService {
        return myInstance
    }

    func setupLocationManager () {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func startLocationUpdates () {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates () {
        locationManager.stopUpdatingLocation()
    }
    
    open func locationManager(_ manager: CLLocationManager,
                              didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else {
            return;
        }
        
        let curTime = Date().timeIntervalSince1970
        
        if ((lastLocUpdateTS == 0.0) || ((curTime > lastLocUpdateTS) &&
            (curTime - lastLocUpdateTS > LOCATION_UPDATE_TIME_INTERVAL))) {
            
            // switch to high accuracy mode
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        } else {
            return;
        }
        
        // how old is this newLocation?
        let age: TimeInterval = -newLocation.timestamp.timeIntervalSinceNow
        if (age > UPDATES_AGE_TIME) {
            return
        }
        
        // ignore old (cached) and less accurate updates
        if ((newLocation.horizontalAccuracy < 0) ||
            (newLocation.horizontalAccuracy > DESIRED_HORIZONTAL_ACCURACY)) {
            return
        }
        
        // update the timestamp
        lastLocUpdateTS = curTime
        
        // switch back to low accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        if let userLocation:CLLocation = newLocation {
            
            // update the location on the webserver
            WebInterface.makeWebRequestAndDiscardError(
                {() -> Void in
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    client.updateLocation(
                        "driver", 
                        latitude: userLocation.coordinate.latitude as NSNumber!,
                        longitude: userLocation.coordinate.longitude as NSNumber!,
                        completion: {(success, error) -> Void in
                            
                            // TODO: FIX error
                            if (error == nil) {
                                // Successfully updated driver location
                            } else {
                                // If there is an error updating driver location, do something?
                                
                            }
                    })
            })
        }
    }
}


