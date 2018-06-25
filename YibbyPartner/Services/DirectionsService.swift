//
//  DirectionsService.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/14/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaLumberjack

// LocationService singleton
class DirectionsService {
    
    // MARK: - Properties
    fileprivate let GOOGLE_SERVER_KEY = "AIzaSyDJ4MgpeQ33SQ9Bv9_wKFzbwK9Jpkivo3I"
    static let shared = DirectionsService()
    let directionsAPI: PXGoogleDirections!
    
    init () {
        directionsAPI = PXGoogleDirections(apiKey: GOOGLE_SERVER_KEY) // A valid server-side API key is required here
    }
    
    func drawRoute(mapView: GMSMapView, loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
        directionsAPI.from = PXLocation.coordinateLocation(loc1)
        directionsAPI.to = PXLocation.coordinateLocation(loc2)
        directionsAPI.mode = PXGoogleDirectionsMode.driving
        directionsAPI.trafficModel = PXGoogleDirectionsTrafficModel.optimistic
        directionsAPI.region = "us"
        
        directionsAPI.calculateDirections { (response) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                switch response {
                case let .error(_, error):
                    
                    DDLogVerbose("Error: \(error)")
                    
                    // Don't do anything.
                    break
                    
                case let .success(request, routes):
                    
                    DDLogVerbose("Success: \(request) \(routes)")
                    routes[0].drawOnMap(mapView, approximate: false, strokeColor: UIColor.appDarkBlue1(), strokeWidth: 5.0)
                }
            })
        }
    }
    
    func getEta(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D,
                completionBlock: @escaping (_ etaSeconds: TimeInterval, _ distanceMeters: CLLocationDistance) -> Void) {
        directionsAPI.from = PXLocation.coordinateLocation(from)
        directionsAPI.to = PXLocation.coordinateLocation(to)
        directionsAPI.mode = PXGoogleDirectionsMode.driving
        directionsAPI.trafficModel = PXGoogleDirectionsTrafficModel.optimistic
        directionsAPI.region = "us"
        
        directionsAPI.calculateDirections { (response) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                switch response {
                case let .error(_, error):
                    
                    DDLogVerbose("Error: \(error)")
                    // Don't do anything.
                    break
                    
                case let .success(request, routes):
                    
                    DDLogVerbose("Success: \(request) \(routes)")
                    completionBlock(routes[0].totalDuration, routes[0].totalDistance)
                }
            })
        }
    }
}
