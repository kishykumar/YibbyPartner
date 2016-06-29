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
import CocoaLumberjack

// TODO: 
// 1. Enable push notifications for Google needs to retry with exponential backoffs
// 2. Push notifications 

class MainViewController: UIViewController {

    // MARK: Properties
    let BAASBOX_AUTHENTICATION_ERROR = -22222

    let ddLogLevel: DDLogLevel = DDLogLevel.Verbose
    
    // MARK: Actions
    @IBAction func leftSlideButtonTapped(sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func onOnlineButtonClick(sender: UIButton) {
        
        // Check for location
        if (!Util.displayLocationAlert()) {
            return;
        }
        
//        let derViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DriverEnRouteViewControllerIdentifier") as! DriverEnRouteViewController
//        self.navigationController!.pushViewController(derViewController, animated: true)
//        return;
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                Util.enableActivityIndicator(self.view)
                let client: BAAClient = BAAClient.sharedClient()
                
                client.updateDriverStatus(BAASBOX_DRIVER_STATUS_ONLINE, completion: {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    Util.disableActivityIndicator(self.view)
                    if (error == nil) {
                        let driverOnlineViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DriverOnlineViewControllerIdentifier") as! DriverOnlineViewController
                        
                        // get the navigation VC and push the new VC
                        self.navigationController!.pushViewController(driverOnlineViewController, animated: true)
                    }
                    else {
                        errorBlock(success, error)
                    }
                })
        })
    }
    
    @IBAction func unwindToMainViewController(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: Setup Functions
    func setupUI () {
 
    }
    
    func afterViewLoadOps(sender: AnyObject) {
        
//        let client: BAAClient = BAAClient.sharedClient()
//        if (client.isDriverOnline()) {
//          self.performSegueWithIdentifier("goOnlineSegue", sender: nil)
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
        self.performSelector(#selector(afterViewLoadOps), withObject: nil, afterDelay: 0.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}