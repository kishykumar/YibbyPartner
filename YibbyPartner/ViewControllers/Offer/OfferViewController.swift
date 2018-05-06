//
//  OfferViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/6/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import BaasBoxSDK
import CocoaLumberjack

class OfferViewController: BaseYibbyViewController {

    // MARK: Properties
    @IBOutlet weak var highBidPriceOutlet: UILabel!
    @IBOutlet weak var offerPriceOutlet: UILabel!
    @IBOutlet weak var currentTimerValueOutlet: UILabel!
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    @IBOutlet weak var acceptButtonOutlet: YibbyButton1!
    
    var curLocation: YBLocation?
    
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

    // MARK: Actions
    
    @IBAction func acceptRequestAction(_ sender: UIButton) {
        
        let userBid = YBClient.sharedInstance().bid!
        
        DDLogInfo("Called: \(String(describing: self.offerPriceOutlet.text))")
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                client.createOffer(
                    userBid.id,
                    offerPrice: Int(self.offerPriceOutlet.text!) as NSNumber!,
                    completion: {(success, error) -> Void in
                        
                        // diable the loading activity indicator
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        self.stopOfferTimer()
                        
                        if (error == nil) {
                            DDLogVerbose("created offer \(String(describing: success))")
                            
                            YBClient.sharedInstance().status = .offerSent
                            self.performSegue(withIdentifier: "offerSentSegue", sender: nil)
                        }
                        else {
                            errorBlock(success, error)
                        }
                })
        })
    }
    
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
    
    @IBAction func declineRequestAction(_ sender: UIButton) {
        
    }
    
    @IBAction func incrementOfferPriceAction(_ sender: AnyObject) {
        let userBid = YBClient.sharedInstance().bid!
        let offerPrice: Int = Int(offerPriceOutlet.text!)! + 1
        let bidHigh: Int = Int(userBid.bidHigh!)
        
        // increment only if the offer price is less than bidHigh
        if (offerPrice < bidHigh) {
            offerPriceOutlet.text = String(offerPrice)
        }
    }
    
    @IBAction func decrementOfferPriceAction(_ sender: AnyObject) {
        if (Int(offerPriceOutlet.text!) != 0) {
            offerPriceOutlet.text = String(Int(offerPriceOutlet.text!)! - 1)
        }
    }
    
    // MARK: Setup
    fileprivate func setupUI () {
        
        let userBid = YBClient.sharedInstance().bid!
        
        // hide the back button
        navigationItem.setHidesBackButton(true, animated: false)
        
        acceptButtonOutlet.color = UIColor.appDarkGreen1()
        acceptButtonOutlet.buttonCornerRadius = 0.0
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        
        highBidPriceOutlet.text = "$ \(String(Int(userBid.bidHigh!)))"
        offerPriceOutlet.text = String(Int(userBid.bidHigh!))
        
        currentTimerValueOutlet.text = String(Int(timerStart))
        
        // set pickup and dropoff
        setPickupDetails(userBid.pickupLocation!)
        setDropoffDetails(userBid.dropoffLocation!)
        
        adjustGMSCameraFocus()
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
    
    fileprivate func startOfferTimer() {
        offerTimer = Timer.scheduledTimer(timeInterval: OfferViewController.OFFER_TIMER_INTERVAL,
                                            target: self,
                                            selector: #selector(OfferViewController.updateTimer),
                                            userInfo: nil,
                                            repeats: true)
    }
    
    @objc fileprivate func stopOfferTimer() {
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
            
            AlertUtil.displayAlert("Time expired.", message: "You missed sending the bid. Missing a lot of bids would bring you offline.", completionBlock: {() -> Void in
                
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
