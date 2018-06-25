//
//  OfferViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/6/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import GoogleMaps
import BaasBoxSDK
import CocoaLumberjack
import ObjectMapper

protocol OfferViewControllerDelegate {
    func startRide()
}

class OfferViewController: BaseYibbyViewController {

    // MARK: Properties
    @IBOutlet weak var highBidPriceOutlet: UILabel!
    @IBOutlet weak var offerPriceOutlet: UILabel!
    @IBOutlet weak var currentTimerValueOutlet: UILabel!
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    @IBOutlet weak var etaToRiderLabelOutlet: UILabel!
    @IBOutlet weak var milesLabelOutlet: UILabel!
    @IBOutlet weak var etaToDropoffLabelOutlet: UILabel!
    
    var pickupLocation: YBLocation?
    var pickupMarker: GMSMarker?
    
    var dropoffLocation: YBLocation?
    var dropoffMarker: GMSMarker?

    let GMS_DEFAULT_CAMERA_ZOOM: Float = 14.0

    var offerTimer: Timer = Timer()
    
    static let OFFER_TIMER_INTERVAL: Double = 1.0
    static let OFFER_TIMER_EXPIRE_PERIOD: Double = 25.0 // 25 seconds
    static let OFFER_TIMER_EXPIRE_MSG_TITLE: String = "Time expired."
    static let OFFER_TIMER_EXPIRE_MSG_CONTENT: String = "Reason: You were given 30 seconds to respond to the ride request."
    
    var timerCount: TimeInterval = 0.0
    var timerStart: TimeInterval!
    
    var savedBgTimestamp: Date?
    var delegate: MainViewController!
    
    // MARK: Actions
    
    @IBAction func onDeclineOfferClick(_ sender: UIButton) {
        // Stop the offer timer right away!
        
        self.stopOfferTimer()
        
        let userBid = YBClient.sharedInstance().bid!
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                client.rejectBid(
                    userBid.id,
                    completion: {(success, error) -> Void in
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        
                        // Clear the saved bid
                        YBClient.sharedInstance().bid = nil
                        
                        if (error == nil) {
                            DDLogVerbose("Rejected offer \(String(describing: success))")
                            
                            YBClient.sharedInstance().status = .online
                            YBClient.sharedInstance().bid = nil

                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            errorBlock(success, error)
                        }
                })
        })
    }
    
    @IBAction func onAccceptOfferClick(_ sender: UIButton) {
        
        self.stopOfferTimer()

        let userBid = YBClient.sharedInstance().bid!
        
        DDLogInfo("Called: \(String(describing: self.offerPriceOutlet.text))")
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                client.acceptBid(userBid.id,
                    completion: {(success, error) -> Void in
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        
                        if let success = success {
                            DDLogVerbose("Offer accepted? \(String(describing: success))")
                            
                            let ride: Ride = Mapper<Ride>().map(JSONObject: success)!
                            if (ride.id != nil) {
                            
                                // Initialize the ride
                                YBClient.sharedInstance().ride = ride
                                YBClient.sharedInstance().status = .driverEnRoute
                                
                                self.delegate.startRide()
                            } else {
                                YBClient.sharedInstance().status = .online
                                YBClient.sharedInstance().bid = nil
                                
                                AlertUtil.displayAlert("Offer Rejected.",
                                                       message: "Reason: Your offer was not the first.",
                                                       completionBlock: {() -> Void in
                                                        
                                                        self.dismiss(animated: true, completion: nil)
                                })
                            }
                        }
                        else {
                            errorBlock(success, error)
                        }
                })
        })
    }

    // MARK: Setup
    fileprivate func setupUI () {
        
        if let userBid = YBClient.sharedInstance().bid {
        
            // hide the back button
            navigationItem.setHidesBackButton(true, animated: false)
            
            navigationController?.navigationBar.barTintColor = UIColor.red
            
            highBidPriceOutlet.text = "$ \(String(Int(userBid.bidPrice!)))"
            offerPriceOutlet.text = String(Int(userBid.bidPrice!))
            
            currentTimerValueOutlet.text = String(Int(timerStart))
            
            // set pickup and dropoff
            setPickupDetails(userBid.pickupLocation!)
            setDropoffDetails(userBid.dropoffLocation!)
            
            adjustGMSCameraFocus()
            
            setTripDetails(pickupLoc: userBid.pickupLocation!, dropoffLoc: userBid.dropoffLocation!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
        DDLogVerbose("TimerStart: \(timerStart)")
        startOfferTimer()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Notifications
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(OfferViewController.saveOfferTimer),
                                               name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OfferViewController.restoreOfferTimer),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    fileprivate func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: Helpers
    
    
    fileprivate func adjustGMSCameraFocus () {
        
        let highBidPriceRelativeOrigin: CGPoint =
            (highBidPriceOutlet.superview?.convert(highBidPriceOutlet.frame.origin,
                                                   to: gmsMapViewOutlet))!
        
        if let pickup = pickupMarker, let dropoff = dropoffMarker {
            
            let bounds = GMSCoordinateBounds(coordinate: pickup.position, coordinate: dropoff.position)
            let insets = UIEdgeInsets(top: self.topLayoutGuide.length + (pickup.icon?.size.height)! + 10.0,
                                      left: ((pickup.icon?.size.width)! / 2) + 10.0,
                                      bottom: gmsMapViewOutlet.frame.height - highBidPriceRelativeOrigin.y + 10.0,
                                      right: ((pickup.icon?.size.width)! / 2) + 10.0)
            
            let update = GMSCameraUpdate.fit(bounds, with: insets)
            gmsMapViewOutlet.moveCamera(update)
            
        }
    }
    
    fileprivate func setPickupDetails (_ location: YBLocation) {
        
        pickupMarker?.map = nil
        
        self.pickupLocation = location
        
        let pumarker = GMSMarker(position: location.coordinate())
        pumarker.map = gmsMapViewOutlet
        
        pumarker.icon = YibbyMapMarker.annotationImageWithMarker(pumarker,
                                                                 title: location.name!,
                                                                 type: .pickup)
        
        pickupMarker = pumarker
    }
    
    fileprivate func setDropoffDetails (_ location: YBLocation) {
        
        dropoffMarker?.map = nil
        
        self.dropoffLocation = location
        
        let domarker = GMSMarker(position: location.coordinate())
        domarker.map = gmsMapViewOutlet
        
        //        domarker.icon = UIImage(named: "Visa")
        domarker.icon = YibbyMapMarker.annotationImageWithMarker(domarker,
                                                                 title: location.name!,
                                                                 type: .dropoff)
        
        dropoffMarker = domarker
    }
    
    fileprivate func setTripDetails(pickupLoc: YBLocation, dropoffLoc: YBLocation) {
        
        self.milesLabelOutlet.text = "Loading"
        self.etaToDropoffLabelOutlet.text = "Loading"
        self.etaToRiderLabelOutlet.text = "Loading"
        
        DirectionsService.shared.getEta(from: pickupLoc.coordinate(), to: dropoffLoc.coordinate(),
            completionBlock: { (etaSeconds, distanceMeters) -> Void in
                
                let etaMins: Int = (Int(etaSeconds) + 59) / 60
                let miles: Int = (Int(distanceMeters) + 1608) / 1609
                
                self.etaToDropoffLabelOutlet.text = "\(etaMins) mins"
                self.milesLabelOutlet.text = "\(miles) miles"
        })
        
        if let driverLoc = LocationService.sharedInstance().getNoWaitCurLocation() {
            
            DirectionsService.shared.getEta(from: driverLoc.coordinate, to: pickupLoc.coordinate(),
                completionBlock: { (etaSeconds, distanceMeters) -> Void in
                    
                    var etaMins: Int = (Int(etaSeconds) + 59) / 60
                    if (etaMins == 0) {
                        etaMins = 1 // minimum 1 minute
                    }
                    
                    self.etaToRiderLabelOutlet.text = "\(etaMins) mins"
            })
        }
    }
    
    fileprivate func startOfferTimer() {
        setupNotificationObservers()
        
        offerTimer = Timer.scheduledTimer(timeInterval: OfferViewController.OFFER_TIMER_INTERVAL,
                                            target: self,
                                            selector: #selector(OfferViewController.updateTimer),
                                            userInfo: nil,
                                            repeats: true)
    }
    
    @objc fileprivate func stopOfferTimer() {
        removeNotificationObservers()
        offerTimer.invalidate()
    }
    
    @objc fileprivate func saveOfferTimer () {
        DDLogVerbose("Called")
        
        // if there is an active bid, save the current time
        if (YBClient.sharedInstance().isOngoingBid()) {
            let curTime = Date()
            DDLogDebug("Setting bgtime \(curTime))")
            savedBgTimestamp = curTime
        }
    }
    
    @objc fileprivate func restoreOfferTimer () {
        DDLogVerbose("Called")
        
        if (YBClient.sharedInstance().isOngoingBid()) {

            if let appBackgroundedTime = savedBgTimestamp {

                let elapsedTime = TimeInterval(Int(TimeUtil.diffFromCurTime(appBackgroundedTime))) // seconds

                DDLogDebug("bgtime \(appBackgroundedTime) bumpUpTime \(elapsedTime))")
                
                // bump up the timer count by the number of seconds surpassed
                timerCount += elapsedTime
                
                // update the Timer label
                if (timerStart > timerCount) {
                    currentTimerValueOutlet.text = String(Int(timerStart - timerCount))
                } else {
                    currentTimerValueOutlet.text = String(Int(0))
                }
                
                savedBgTimestamp = nil
            }
        }
    }
    
    @objc fileprivate func updateTimer() {

        // increment the timer count
        timerCount += OfferViewController.OFFER_TIMER_INTERVAL
        
        // if the counter reached MAX_TIME, dismiss the offerController, show the error message and take the driver back
        if (timerCount > timerStart) {
            
            DDLogVerbose("Resetting the bidState in updateTimer")
            
            // delete the saved state bid
            YBClient.sharedInstance().bid = nil
            
            AlertUtil.displayAlertOnVC(self, title: "Time expired.", message: "You missed sending the bid.", completionBlock: {() -> Void in
                
                YBClient.sharedInstance().status = .online
                self.dismiss(animated: true, completion: nil)
            })
            
            stopOfferTimer()

            return
        }
        
        // update the Timer label
        currentTimerValueOutlet.text = String(Int(timerStart - timerCount))
    }
}
