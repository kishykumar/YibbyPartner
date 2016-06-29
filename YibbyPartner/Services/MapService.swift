//
//  MapService.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/10/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import BaasBoxSDK
import CocoaLumberjack
import OpenInGoogleMaps

// MapService singleton
public class MapService: NSObject {
    
    private static let myInstance = MapService()
    
    override init() {
        
    }
    
    static func sharedInstance () -> MapService {
        return myInstance
    }
    
    func setupMapService() {
        setupOpenInGoogleMaps()
    }
    
    private func setupOpenInGoogleMaps () {
        
        // set our callback URL
        OpenInGoogleMapsController.sharedInstance().callbackURL =
            NSURL(string: (Util.getAppURLScheme() + ":\\"))
        
        // If the user doesn't have Google Maps installed, let's try Apple Maps.
        // This gives us the best chance of having an x-callback-url that points back to our application.
        OpenInGoogleMapsController.sharedInstance().fallbackStrategy = GoogleMapsFallback.AppleMaps
    }
    
    func openDirectionsInGoogleMaps (lat: CLLocationDegrees, lng: CLLocationDegrees) {

        let directionsDefinition: GoogleDirectionsDefinition  = GoogleDirectionsDefinition()
        directionsDefinition.startingPoint = nil;
        directionsDefinition.destinationPoint =
            GoogleDirectionsWaypoint(location: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        
        directionsDefinition.travelMode = GoogleMapsTravelMode.Driving
        OpenInGoogleMapsController.sharedInstance().openDirections(directionsDefinition)
    }
}