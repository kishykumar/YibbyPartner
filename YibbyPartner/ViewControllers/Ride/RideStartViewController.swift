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

class RideStartViewController: BaseYibbyViewController {

    // MARK: Properties
    
    var bid: Bid!
    
    // MARK: Actions
    
    @IBAction func startNavAction(_ sender: AnyObject) {
        MapService.sharedInstance().openDirectionsInGoogleMaps(self.bid.dropoffLat,
                                                               lng: self.bid.dropoffLong)
    }
    
    @IBAction func destArrivedAction(_ sender: AnyObject) {
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                
                client.endRide(self.bid.id, completion: {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    if (error == nil) {
                    
                        let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)

                        let rideEndViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideEndViewControllerIdentifier") as! RideEndViewController
                        
                        // get the navigation VC and push the new VC
                        self.navigationController!.pushViewController(rideEndViewController, animated: true)
                    }
                    else {
                        errorBlock(success, error)
                    }
                })
        })
    }
    
    // MARK: Setup functions
    
    func initProperties() {
        self.bid = (BidState.sharedInstance().getOngoingBid())!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProperties()
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
