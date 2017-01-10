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

class MainViewController: BaseYibbyViewController {

    // MARK: Properties
    let BAASBOX_AUTHENTICATION_ERROR = -22222

    let ddLogLevel: DDLogLevel = DDLogLevel.verbose
    
    // MARK: Actions
    @IBAction func leftSlideButtonTapped(_ sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func onOnlineButtonClick(_ sender: UIButton) {
        
        // Check for location
        if (!AlertUtil.displayLocationAlert()) {
            return;
        }
        
//        let derViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DriverEnRouteViewControllerIdentifier") as! DriverEnRouteViewController
//        self.navigationController!.pushViewController(derViewController, animated: true)
//        return;
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                let client: BAAClient = BAAClient.shared()
                
                client.updateDriverStatus(BAASBOX_DRIVER_STATUS_ONLINE, completion: {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    if (error == nil) {
                        let onlineStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Online, bundle: nil)

                        let driverOnlineViewController = onlineStoryboard.instantiateViewController(withIdentifier: "DriverOnlineViewControllerIdentifier") as! DriverOnlineViewController
                        
                        // get the navigation VC and push the new VC
                        self.navigationController!.pushViewController(driverOnlineViewController, animated: true)
                    }
                    else {
                        errorBlock(success, error)
                    }
                })
        })
    }
    
    @IBAction func unwindToMainViewController(_ segue:UIStoryboardSegue) {
        
    }
    
    // MARK: Setup
    
    static func initMainViewController(_ vc: UIViewController, animated anim: Bool) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.sendGCMTokenToServer()
        
        appDelegate.initializeMainViewController()
        vc.present(appDelegate.centerContainer!, animated: anim, completion: nil)
    }
    
    func setupUI () {
 
    }
    
    func afterViewLoadOps(_ sender: AnyObject) {
        
//        let client: BAAClient = BAAClient.sharedClient()
//        if (client.isDriverOnline()) {
//          self.performSegueWithIdentifier("goOnlineSegue", sender: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
        self.perform(#selector(afterViewLoadOps), with: nil, afterDelay: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
