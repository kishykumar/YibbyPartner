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
    
    @IBAction func onOfflineButtonClick(sender: UIButton) {
    
        // enable the loading activity indicator
        Util.enableActivityIndicator(self.view)

        let client: BAAClient = BAAClient.sharedClient()
        client.updateDriverStatus(BAASBOX_DRIVER_STATUS_OFFLINE, completion: {(success, error) -> Void in

            // diable the loading activity indicator
            Util.disableActivityIndicator(self.view)

            // whether success or error, just pop the view controller. 
            // Webserver will automatically take the driver offline in case of error.
            self.navigationController!.popViewControllerAnimated(true)
        })
        
        // close down all active driver operations
        
        // stop location updates
        LocationService.sharedInstance().stopLocationUpdates()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupMap()
        setupUI()
        LocationService.sharedInstance().startLocationUpdates()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func unwindToDriverOnlineViewController(segue:UIStoryboardSegue) {
        
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
