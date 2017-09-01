//
//  RideStartViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/6/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaLumberjack
import BaasBoxSDK
import BButton

public enum RideViewControllerState: Int {
    case driverEnRoute = 0
    case driverArrived
    case rideStart
    case rideEnd
}

class RideStartViewController: BaseYibbyViewController {

    // MARK: Properties
    
    public var controllerState: RideViewControllerState!
    @IBOutlet weak var rideActionButton: BButton!
    @IBOutlet weak var startNavigationButton: BButton!

    var bid: Bid!
    
    // MARK: Actions
    
    @IBAction func startNavAction(_ sender: AnyObject) {
        
        if (controllerState == RideViewControllerState.driverEnRoute) {
            MapService.sharedInstance().openDirectionsInGoogleMaps((self.bid.dropoffLocation?.latitude)!,
                                                                   lng: (self.bid.dropoffLocation?.longitude)!)
        } else if (controllerState == RideViewControllerState.rideStart) {
            MapService.sharedInstance().openDirectionsInGoogleMaps((self.bid.dropoffLocation?.latitude)!,
                                                                   lng: (self.bid.dropoffLocation?.longitude)!)
        }
    }
    
    @IBAction func destArrivedAction(_ sender: AnyObject) {
        
        // Case 1: Clicked on Arrived at Pickup Point
        if (controllerState == RideViewControllerState.driverEnRoute) {
            
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    client.arrived(atPickup: self.bid.id, completion: {(success, error) -> Void in
                        
                        if (error == nil) {
                        
                            self.controllerState = RideViewControllerState.driverArrived
                            self.rideActionButton.setTitle("Start the ride", for: .normal)

                            self.startNavigationButton.isHidden = true
                            
//                            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
//
//                            let rideEndViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideEndViewControllerIdentifier") as! RideEndViewController
//                            
//                            self.navigationController!.pushViewController(rideEndViewController, animated: true)
                        }
                        else {
                            errorBlock(success, error)
                        }
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    })
            })
            
        }
        
        // Case 2: Driver clicks on Start the ride
        else if (controllerState == RideViewControllerState.driverArrived) {
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    client.startRide(self.bid.id, completion: {(success, error) -> Void in
                        
                        if (error == nil) {
                            
                            self.controllerState = RideViewControllerState.rideStart
                            self.rideActionButton.setTitle("End the ride", for: .normal)
                            self.startNavigationButton.isHidden = false
                        }
                        else {
                            errorBlock(success, error)
                        }
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    })
            })
        }
        
        // Case 3: Driver clicks on End the Ride
        else if (controllerState == RideViewControllerState.rideStart) {
            
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in

                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    client.endRide(self.bid.id, completion: {(success, error) -> Void in
                        
                        if (error == nil) {
                            
                            self.controllerState = RideViewControllerState.rideEnd

                            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)

                            let rideEndViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideEndViewControllerIdentifier") as! RideEndViewController

                            self.navigationController!.pushViewController(rideEndViewController, animated: true)
                            
                        }
                        else {
                            errorBlock(success, error)
                        }
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    })
            })
            
        }
    }
    
    // MARK: Setup functions
    
    func initProperties() {
        self.bid = (YBClient.sharedInstance().getBid())!
        controllerState = RideViewControllerState.driverEnRoute
        
        rideActionButton.setTitle("Arrived at Pickup Location", for: .normal)
    }
    
    func setupUI() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper functions
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
