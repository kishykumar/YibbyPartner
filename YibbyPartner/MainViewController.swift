//
//  ViewController.swift
//  Example
//
//  Created by Kishy Kumar on 1/9/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import MMDrawerController
import TTRangeSlider
import BaasBoxSDK

class MainViewController: UIViewController {

    // MARK: Properties
    let ACTIVITY_INDICATOR_TAG: Int = 1

    // MARK: Functions
    @IBAction func leftSlideButtonTapped(sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func onOnlineButtonClick(sender: UIButton) {

        // enable the loading activity indicator
        Util.enableActivityIndicator(self.view, tag: ACTIVITY_INDICATOR_TAG)
        
        let client: BAAClient = BAAClient.sharedClient()
        client.activateDriver({(success, error) -> Void in
            
            // diable the loading activity indicator
            Util.disableActivityIndicator(self.view, tag: self.ACTIVITY_INDICATOR_TAG)

            if (success) {
                let driverOnlineViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DriverOnlineViewControllerIdentifier") as! DriverOnlineViewController
                
                // get the navigation VC and push the new VC
                self.navigationController!.pushViewController(driverOnlineViewController, animated: true)
            }
            else {
                print("error in making the driver online: \(error)")
            }
        })
    }
    
    func setupUI () {
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}