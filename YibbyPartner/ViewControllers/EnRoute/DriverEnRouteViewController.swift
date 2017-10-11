//
//  DriverEnRouteViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/26/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaLumberjack
import BaasBoxSDK

class DriverEnRouteViewController: BaseYibbyViewController {

    // MARK: Properties
    
    @IBOutlet weak var mapViewOutlet: GMSMapView!
    
    var bid: Bid!

    // MARK: Actions
    
    @IBAction func startNavAction(_ sender: AnyObject) {
        MapService.sharedInstance().openDirectionsInGoogleMaps((self.bid.dropoffLocation?.latitude)!,
                                                               lng: (self.bid.dropoffLocation?.longitude)!)
    }
    
    @IBAction func arrivedAction(_ sender: AnyObject) {

        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                
                client.startRide(self.bid.id, completion: {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    if (error == nil) {
                        
                        let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
                        
                        let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
                        
                        // get the navigation VC and push the new VC
                        self.navigationController!.pushViewController(rideStartViewController, animated: true)

                    }
                    else {
                        errorBlock(success, error)
                    }
                })
        })
    }
    
    // MARK: Setup functions
    
    func initProperties() {
        self.bid = (YBClient.sharedInstance().bid)!
    }
    
    func setupUI () {
        // hide the nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogDebug("Called")
        
        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
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
