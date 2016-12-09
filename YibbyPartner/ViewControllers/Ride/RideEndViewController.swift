//
//  RideEndViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/10/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaLumberjack
import BaasBoxSDK

class RideEndViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var gmsMapViewOutlet: UIView!

    var bid: Bid!

    // MARK: Actions
    
    @IBAction func goOfflineAction(sender: AnyObject) {
        // cleanup the state
        
        // let the webserver know


            // pop all the view controllers and go back to MainViewController
    }
    
    @IBAction func rideFinishAction(sender: AnyObject) {
        // cleanup the state

        // let the webserver know

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
