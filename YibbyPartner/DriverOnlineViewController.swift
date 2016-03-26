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


class DriverOnlineViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    
    let ACTIVITY_INDICATOR_TAG: Int = 1
    
    @IBAction func onOfflineButtonClick(sender: UIButton) {
    
        // enable the loading activity indicator
        Util.enableActivityIndicator(self.view, tag: ACTIVITY_INDICATOR_TAG)

        let client: BAAClient = BAAClient.sharedClient()
        client.deactivateDriver({(success, error) -> Void in

            // diable the loading activity indicator
            Util.disableActivityIndicator(self.view, tag: self.ACTIVITY_INDICATOR_TAG)

            if (success) {
                print("driver offline")
                self.navigationController!.popViewControllerAnimated(true)
            }
            else {
                print("error in making the driver offline: \(error)")
            }
        })
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMap()
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
