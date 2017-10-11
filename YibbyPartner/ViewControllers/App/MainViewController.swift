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

class MainViewController: BaseYibbyViewController {

    // MARK: Properties
    let BAASBOX_AUTHENTICATION_ERROR = -22222

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
    
    fileprivate var bidObserver: NotificationObserver?
    fileprivate var offerObserver: NotificationObserver?
    fileprivate var rideObserver: NotificationObserver?
    
    // MARK: Actions

    @IBAction func onCentersMarkerViewClick(_ sender: UITapGestureRecognizer) {
        
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
            
            // enable the loading activity indicator
            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            client.updateDriverStatus(BAASBOX_DRIVER_STATUS_OFFLINE,
                                      latitude: 18.5,
                                      longitude: 16.3,
                                      completion: {(success, error) -> Void in
                                        
                                        // diable the loading activity indicator
                                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                                        
//                                        // whether success or error, just pop the view controller.
//                                        // Webserver will automatically take the driver offline in case of error.
//                                        self.navigationController!.popViewController(animated: true)
            })
            
            // close down all active driver operations
            
            onlineStatusLabelOutlet.text = "You are offline"
            
            YBClient.sharedInstance().status = .offline
            stopOnlineStatusAnimation()
            
            // stop location updates regardless of whether the request succeeds or fails
            LocationService.sharedInstance().stopLocationUpdates()
            
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
//                            let onlineStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Online, bundle: nil)
//
//                            let driverOnlineViewController = onlineStoryboard.instantiateViewController(withIdentifier: "DriverOnlineViewControllerIdentifier") as! DriverOnlineViewController
//                            
//                            // get the navigation VC and push the new VC
//                            self.navigationController!.pushViewController(driverOnlineViewController, animated: true)
                            
                            self.onlineStatusLabelOutlet.text = "You are online"
                            
                            YBClient.sharedInstance().status = .online
                            self.startOnlineStatusAnimation()

                            LocationService.sharedInstance().startLocationUpdates()
                        }
                        else {
                            errorBlock(success, error)
                        }
                    })
            })
        }
    }
    
    @IBAction func unwindToMainViewController(_ segue:UIStoryboardSegue) {
        
    }
    
    // MARK: Setup

    deinit {
        removeNotificationObservers()
    }
    
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
    
    static func initMainViewController(_ vc: UIViewController, animated anim: Bool) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.sendGCMTokenToServer()
        
        appDelegate.initializeMainViewController()
        vc.present(appDelegate.centerContainer!, animated: anim, completion: nil)
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
        setupMap()
        setupNotificationObservers()

        self.perform(#selector(afterViewLoadOps), with: nil, afterDelay: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notifications
    
    fileprivate func removeNotificationObservers() {
        
        bidObserver?.removeObserver()
        offerObserver?.removeObserver()
        rideObserver?.removeObserver()
        
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
                DDLogDebug("Bid Discarded CurrentTime: \(Date()) bidTime: \(bid.creationTime) bidElapsedTime: \(bidElapsedTime)")
                
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
            
            // if an alert was already displayed, dismiss it
            if let presentedVC = self.presentedViewController {
                if (presentedVC.isMember(of: UIAlertController.self)) {
                    self.dismiss(animated: false, completion: nil)
                }
            }

            self.navigationController?.present(navController, animated: true, completion: nil)
        }
        
        offerObserver = NotificationObserver(notification: BidNotifications.offerRejected) { [unowned self] bid in
            
            if (!YBClient.sharedInstance().isSameAsOngoingBid(bidId: bid.id)) {
                DDLogDebug("Not same as ongoingBid. Discarded. ")
                
                if let ongoingBid = YBClient.sharedInstance().bid {
                    DDLogDebug("Ongoingbid is: \(String(describing: ongoingBid.id)). Incoming is \(String(describing: bid.id))")
                } else {
                    DDLogDebug("Ongoingbid is: nil. Incoming is \(String(describing: bid.id))")
                }
                
                return;
            }
            
            YBClient.sharedInstance().bid = nil
            
            AlertUtil.displayAlert("Offer Rejected.",
                                   message: "Reason: Your offer was not the lowest.",
                                   completionBlock: {() -> Void in
                                        self.dismiss(animated: true, completion: nil)
                                    })
        }
        
        rideObserver = NotificationObserver(notification: RideNotifications.driverEnRoute) { [unowned self] ride in
            
            if (!YBClient.sharedInstance().isSameAsOngoingBid(bidId: ride.bidId)) {
                DDLogDebug("Not same as ongoingBid. Discarded:")
                
                if let ongoingBid = YBClient.sharedInstance().bid {
                    DDLogDebug("Ongoingbid is: \(String(describing: ongoingBid.id)). Incoming is \(String(describing: ride.bidId))")
                } else {
                    DDLogDebug("Ongoingbid is: nil. Incoming is \(String(describing: ride.bidId))")
                }
                
                return;
            }
            
            self.dismiss(animated: true, completion: nil)
            
            let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)
            
            let rideStartViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideStartViewControllerIdentifier") as! RideStartViewController
            
            self.navigationController?.pushViewController(rideStartViewController, animated: true)
        }
    }

    // MARK: - Helpers
    
    fileprivate func adjustGMSCameraFocus(_ location: CLLocationCoordinate2D) {
        let update = GMSCameraUpdate.setTarget((location),
                                               zoom: GMS_DEFAULT_CAMERA_ZOOM)
        self.gmsMapViewOutlet.moveCamera(update)
    }
    
    func startOnlineStatusAnimation() {
        onlineStatusLabelOutlet.animation = "flash"
        onlineStatusLabelOutlet.duration = 1.5
        onlineStatusLabelOutlet.repeatCount = .infinity
        onlineStatusLabelOutlet.animate()
    }
    
    func stopOnlineStatusAnimation() {
        onlineStatusLabelOutlet.layer.removeAllAnimations()
    }
    
    @objc fileprivate func appBecameActive() {
        if (YBClient.sharedInstance().status == .online) {
            startOnlineStatusAnimation()
        } else {
            stopOnlineStatusAnimation()
        }
    }
}
