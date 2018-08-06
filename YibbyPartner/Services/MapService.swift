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
import MapKit

// MapService singleton
open class MapService: NSObject {
    
    fileprivate static let myInstance = MapService()
    
    override init() {
        
    }
    
    static func sharedInstance () -> MapService {
        return myInstance
    }
    
    func setupMapService() {
        setupOpenInGoogleMaps()
    }
    
    fileprivate func setupOpenInGoogleMaps () {
        
        // set our callback URL
        OpenInGoogleMapsController.sharedInstance().callbackURL =
            URL(string: (Util.getAppURLScheme() + ":\\"))
        
        // If the user doesn't have Google Maps installed, let's try Apple Maps.
        // This gives us the best chance of having an x-callback-url that points back to our application.
        OpenInGoogleMapsController.sharedInstance().fallbackStrategy = GoogleMapsFallback.appleMaps
    }
    
    func openDirectionsInGoogleMaps (_ lat: CLLocationDegrees, lng: CLLocationDegrees) {

        let directionsDefinition: GoogleDirectionsDefinition  = GoogleDirectionsDefinition()
        directionsDefinition.startingPoint = nil;
        directionsDefinition.destinationPoint =
            GoogleDirectionsWaypoint(location: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        
        directionsDefinition.travelMode = GoogleMapsTravelMode.driving
        OpenInGoogleMapsController.sharedInstance().openDirections(directionsDefinition)
    }
    //openingooglemaps pod has been deprecated.So we need to use this
    func openInGoogleMap(lat: CLLocationDegrees, long: CLLocationDegrees){
        let url = "comgooglemaps://"
        if UIApplication.shared.canOpenURL(URL(string:url)!){
            UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(lat),\(long)&zoom=10&directionsmode=driving")!, options: [:], completionHandler: nil)
        }
        else{
            openInAppleMap(lat: lat, long: long)
        }
    }
    
    func openInAppleMap(lat: CLLocationDegrees, long: CLLocationDegrees){
        let url = "http://maps.apple.com/maps?saddr=&daddr=\(lat),\(long)"
        if UIApplication.shared.canOpenURL(URL(string:url)!){
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
    
    func openInWaze(lat: CLLocationDegrees, long: CLLocationDegrees){
        let url = "waze://"
        if UIApplication.shared.canOpenURL(URL(string:url)!){
            UIApplication.shared.open(URL(string:"waze://?ll=\(lat),\(long)&navigate=yes")!, options: [:], completionHandler: nil)
        }
        else{
            openInAppleMap(lat: lat, long: long)
        }
    }
    
}
