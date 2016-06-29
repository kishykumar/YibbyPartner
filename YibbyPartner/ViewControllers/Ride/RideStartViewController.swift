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

class RideStartViewController: UIViewController {

    @IBAction func startNavAction(sender: AnyObject) {
        let b: Bid = (BidState.sharedInstance().getOngoingBid())!
        MapService.sharedInstance().openDirectionsInGoogleMaps(b.dropoffLat, lng: b.dropoffLong)
    }
    
    @IBAction func destArrivedAction(sender: AnyObject) {
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                Util.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.sharedClient()
                
                client.dummyCall( {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    Util.disableActivityIndicator(self.view)
                    //                    if (error == nil) {
                    let rideEndViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RideEndViewControllerIdentifier") as! RideEndViewController
                    
                    // get the navigation VC and push the new VC
                    self.navigationController!.pushViewController(rideEndViewController, animated: true)
                    //                    }
                    //                    else {
                    //                        errorBlock(success, error)
                    //                    }
                })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
