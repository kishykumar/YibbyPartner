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
import DGRunkeeperSwitch
import Spring

// TODO: 
// 1. Enable push notifications for Google needs to retry with exponential backoffs
// 2. Push notifications 

class MainViewController: BaseYibbyViewController, OfferViewControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var onlineStatusLabelOutlet: SpringLabel!
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    let ddLogLevel: DDLogLevel = DDLogLevel.verbose
    
    @IBOutlet weak var onlineSwitchOutlet: DGRunkeeperSwitch!
    
    fileprivate enum onlineSwitchIndex: Int {
        case offline = 0
        case online = 1
    }
    
    let GMS_DEFAULT_CAMERA_ZOOM: Float = 14.0
    static let BID_NOTIFICATION_EXPIRE_TIME: TimeInterval = 30 // seconds

    // Today, DGRunkeeperSwitch fires the valueChanged event even on setting the default value.
    // As a workaround, we skip the first event by using this variable. 
    var firstValueChangedSkipped = false
    
    fileprivate var bidObserver: NotificationObserver? // for incoming offer
    
    // MARK: Actions

    @IBAction func onCentersMarkerViewClick(_ sender: UITapGestureRecognizer) {
        
//        // prepare the offerViewController
//        let offerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Offer, bundle: nil)
//        
//        let offerViewController = offerStoryboard.instantiateViewController(withIdentifier: "OfferViewControllerIdentifier") as! OfferViewController
//        
//        let navController = UINavigationController(rootViewController: offerViewController)
//        
//        // start the timer by accouting the time elapsed since the user actually created the bid
//        offerViewController.timerStart = 30
//
//        self.navigationController?.present(navController, animated: true, completion: nil)
//
//        return;
        
        if let driverLocation = gmsMapViewOutlet.myLocation {
            adjustGMSCameraFocus(driverLocation.coordinate)
        }
    }
    
    @IBAction func onOnlineSwitchValueChange(_ sender: DGRunkeeperSwitch) {
        
        if (!firstValueChangedSkipped) {
            firstValueChangedSkipped = true
            return;
        }
        
        if (sender.selectedIndex == onlineSwitchIndex.offline.rawValue) {
            // Offline
            
            // close down all active driver operations
            
            onlineStatusLabelOutlet.text = "You are offline"
            
            YBClient.sharedInstance().status = .offline
            stopOnlineStatusAnimation()
            
            // stop location updates regardless of whether the request succeeds or fails
            LocationService.sharedInstance().stopLocationUpdates()
            
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                client.updateDriverStatus(BAASBOX_DRIVER_STATUS_OFFLINE,
                  latitude: 18.5, // random coordinates
                  longitude: 16.3,
                  completion: {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    
                    // Check for error
                    if (error == nil) {
                        errorBlock(success, error)
                    }
                })
            })
            
        } else {
            // Online
            
            // Check for location
            if (!AlertUtil.displayLocationAlert()) {
                return;
            }

            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    let client: BAAClient = BAAClient.shared()
                    
                    client.updateDriverStatus(BAASBOX_DRIVER_STATUS_ONLINE,
                                              latitude: 18.5,
                                              longitude: 16.3,
                                              completion: {(success, error) -> Void in
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        if (error == nil) {
                            
                            self.onlineStatusLabelOutlet.text = "You are online"
                            
                            YBClient.sharedInstance().status = .online
                            self.startOnlineStatusAnimation()

                            LocationService.sharedInstance().startLocationUpdates()
                        }
                        else {
                            errorBlock(success, error)
                            
                            self.onlineSwitchOutlet.setSelectedIndex(onlineSwitchIndex.offline.rawValue, animated: false)
                        }
                    })
            })
        }
    }
    
    @IBAction func unwindToMainViewController(_ segue:UIStoryboardSegue) {
        
    }
    
    // MARK: Setup

    fileprivate func setupMap () {
        gmsMapViewOutlet.isMyLocationEnabled = true
        
        // Very Important: DONT disable consume all gestures because it's needed for nav drawer with a map
        gmsMapViewOutlet.settings.consumesGesturesInView = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let curLocation = LocationService.sharedInstance().provideCurrentLocation() {
                DispatchQueue.main.async {
                    self.adjustGMSCameraFocus(curLocation.coordinate)
                }
            }
        }
    }
    
    fileprivate func setupUI () {
        // hide the back button
        setupMenuButton()
        
        if let onlineSwitchOutlet = onlineSwitchOutlet {
            onlineSwitchOutlet.titles = ["Offline", "Online"]
            onlineSwitchOutlet.backgroundColor = UIColor(red: 122/255.0, green: 203/255.0, blue: 108/255.0, alpha: 1.0)
            onlineSwitchOutlet.selectedBackgroundColor = .white
            onlineSwitchOutlet.titleColor = .white
            onlineSwitchOutlet.selectedTitleColor = UIColor(red: 135/255.0, green: 227/255.0, blue: 120/255.0, alpha: 1.0)
            onlineSwitchOutlet.titleFont = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        }
        
        if (YBClient.sharedInstance().status == .online) {
            self.onlineStatusLabelOutlet.text = "You are online"
            startOnlineStatusAnimation()
            onlineSwitchOutlet.setSelectedIndex(onlineSwitchIndex.online.rawValue, animated: false)
        } else {
            self.onlineStatusLabelOutlet.text = "You are offline"
            stopOnlineStatusAnimation()
            onlineSwitchOutlet.setSelectedIndex(onlineSwitchIndex.offline.rawValue, animated: false)
        }
    }

    @objc func afterViewLoadOps(_ sender: AnyObject) {
        
//        let client: BAAClient = BAAClient.sharedClient()
//        if (client.isDriverOnline()) {
//          self.performSegueWithIdentifier("goOnlineSegue", sender: nil)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
        setupMap()

        self.perform(#selector(afterViewLoadOps), with: nil, afterDelay: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    private func commonInit() {
        DDLogVerbose("Fired init")
        setupNotificationObservers()
    }
    
    deinit {
        DDLogVerbose("Fired deinit")
        removeNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (YBClient.sharedInstance().status == .online) {
            startOnlineStatusAnimation()
        } else {
            stopOnlineStatusAnimation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notifications
    
    fileprivate func removeNotificationObservers() {
        
        bidObserver?.removeObserver()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    fileprivate func setupNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.appBecameActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        bidObserver = NotificationObserver(notification: BidNotifications.bidReceived) { [unowned self] bid in
            DDLogVerbose("NotificationObserver bidRcvd: \(bid)")
            
            // Initialize the client bid state
            YBClient.sharedInstance().bid = bid

            let bidElapsedTime = TimeUtil.diffFromCurTimeISO(bid.creationTime!)
            
            if (bidElapsedTime > MainViewController.BID_NOTIFICATION_EXPIRE_TIME) {
                DDLogDebug("Bid Discarded CurrentTime: \(Date()) bidTime: \(String(describing: bid.creationTime)) bidElapsedTime: \(bidElapsedTime)")
                
                // Clear the bid before exiting
                YBClient.sharedInstance().bid = nil;
                
                // The driver missed responding to the bid
                AlertUtil.displayAlert("Bid missed.",
                                       message: "Reason: You missed sending the bid. Missing a lot of bids would bring you offline.")
                return;
            }

            // prepare the offerViewController
            let offerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Offer, bundle: nil)

            let offerViewController = offerStoryboard.instantiateViewController(withIdentifier: "OfferViewControllerIdentifier") as! OfferViewController

            let navController = UINavigationController(rootViewController: offerViewController)
            
            // start the timer by accouting the time elapsed since the user actually created the bid
            offerViewController.timerStart = TimeInterval(Int(OfferViewController.OFFER_TIMER_EXPIRE_PERIOD - bidElapsedTime))
            offerViewController.delegate = self
            
            // if an alert was already displayed, dismiss it
            if self.presentedViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }

            YBClient.sharedInstance().status = .offerInProcess
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }

    // MARK: - Helpers
    
    fileprivate func adjustGMSCameraFocus(_ location: CLLocationCoordinate2D) {
        let update = GMSCameraUpdate.setTarget((location),
                                               zoom: GMS_DEFAULT_CAMERA_ZOOM)
        self.gmsMapViewOutlet.moveCamera(update)
    }
    
    fileprivate func startOnlineStatusAnimation() {
        onlineStatusLabelOutlet.animation = "flash"
        onlineStatusLabelOutlet.duration = 1.5
        onlineStatusLabelOutlet.repeatCount = .infinity
        onlineStatusLabelOutlet.animate()
    }
    
    fileprivate func stopOnlineStatusAnimation() {
        onlineStatusLabelOutlet.layer.removeAllAnimations()
    }
    
    @objc fileprivate func appBecameActive() {
        
        if (!self.isViewLoaded) {
            return;
        }
        
        if (YBClient.sharedInstance().status == .online) {
            startOnlineStatusAnimation()
        } else {
            stopOnlineStatusAnimation()
        }
    }
    
    // MARK: - OfferViewControllerDelegate
    
    func startRide() {
        self.dismiss(animated: true, completion: {
            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
            
            let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
            
            self.navigationController?.pushViewController(rideStartViewController, animated: true)
        })
    }
}
