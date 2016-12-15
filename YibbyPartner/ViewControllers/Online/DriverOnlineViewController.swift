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


class DriverOnlineViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    
    @IBAction func onOfflineButtonClick(_ sender: UIButton) {
    
        // enable the loading activity indicator
        ActivityIndicatorUtil.enableActivityIndicator(self.view)

        let client: BAAClient = BAAClient.shared()
        client.updateDriverStatus(BAASBOX_DRIVER_STATUS_OFFLINE, completion: {(success, error) -> Void in

            // diable the loading activity indicator
            ActivityIndicatorUtil.disableActivityIndicator(self.view)

            // whether success or error, just pop the view controller. 
            // Webserver will automatically take the driver offline in case of error.
            self.navigationController!.popViewController(animated: true)
        })
        
        // close down all active driver operations
        
        // stop location updates
        LocationService.sharedInstance().stopLocationUpdates()
    }
    
    func setupMap () {
        gmsMapViewOutlet.isMyLocationEnabled = true
        gmsMapViewOutlet.settings.myLocationButton = true
        
        // Very Important: DONT disable consume all gestures, needed for nav drawer with a map
        gmsMapViewOutlet.settings.consumesGesturesInView = true
    }
    
    func setupUI () {
        
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        gmsMapViewOutlet.isMyLocationEnabled = true
        gmsMapViewOutlet.settings.myLocationButton = true
        
        // Very Important: DONT disable consume all gestures, needed for nav drawer with a map
        gmsMapViewOutlet.settings.consumesGesturesInView = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupMap()
        setupUI()
        LocationService.sharedInstance().startLocationUpdates()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func unwindToDriverOnlineViewController(_ segue:UIStoryboardSegue) {
        
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
