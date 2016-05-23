//
//  DriverOnlineViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/6/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import BaasBoxSDK
import CocoaLumberjack


class DriverOnlineViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Properties
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    
    let ACTIVITY_INDICATOR_TAG: Int = 1
    var locationManager:CLLocationManager!
    let UPDATES_AGE_TIME: NSTimeInterval = 120
    let DESIRED_HORIZONTAL_ACCURACY = 200.0
    let LOCATION_UPDATE_TIME_INTERVAL = 4.0 // seconds
    
    var lastLocUpdateTS = 0.0
    
    @IBAction func onOfflineButtonClick(sender: UIButton) {
    
        // enable the loading activity indicator
        Util.enableActivityIndicator(self.view, tag: ACTIVITY_INDICATOR_TAG)

        let client: BAAClient = BAAClient.sharedClient()
        client.deactivateDriver({(success, error) -> Void in

            // diable the loading activity indicator
            Util.disableActivityIndicator(self.view, tag: self.ACTIVITY_INDICATOR_TAG)

            // whether success or error, just pop the view controller. 
            // Webserver will automatically take the driver offline in case of error.
            self.navigationController!.popViewControllerAnimated(true)
        })
        
        // close down all active driver operations
//        locationManager.stopUpdatingLocation()
    }
    
    func setupMap () {
        gmsMapViewOutlet.myLocationEnabled = true
        gmsMapViewOutlet.settings.myLocationButton = true
        
        // Very Important: DONT disable consume all gestures, needed for nav drawer with a map
        gmsMapViewOutlet.settings.consumesGesturesInView = true
    }
    
    func setupUI () {
        
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        gmsMapViewOutlet.myLocationEnabled = true
        gmsMapViewOutlet.settings.myLocationButton = true
        
        // Very Important: DONT disable consume all gestures, needed for nav drawer with a map
        gmsMapViewOutlet.settings.consumesGesturesInView = true
    }
    
    func setupLocationManager () {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        let curTime = NSDate().timeIntervalSince1970
        
        if ((lastLocUpdateTS == 0.0) || ((curTime > lastLocUpdateTS) &&
            (curTime - lastLocUpdateTS > LOCATION_UPDATE_TIME_INTERVAL))) {
            
            // switch to high accuracy mode
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        } else {
            return;
        }
        
        // how old is this newLocation?
        let age: NSTimeInterval = -newLocation.timestamp.timeIntervalSinceNow
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
                self,
                webRequest: {() -> Void in
                    
                    let client: BAAClient = BAAClient.sharedClient()
                    
                    client.updateDriverLocation(
                        userLocation.coordinate.latitude,
                        lng: userLocation.coordinate.longitude,
                        completion: {(success, error) -> Void in

                        // TODO: Fix me
                        if (error == nil) {
                            DDLogVerbose ("Successfully updated driver location")
                        } else {
                            DDLogVerbose ("Error updating driver location")
                        }
                    })
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupMap()
        setupUI()
        setupLocationManager()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
