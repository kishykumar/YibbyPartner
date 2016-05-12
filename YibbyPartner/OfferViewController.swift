//
//  OfferViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/6/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import BaasBoxSDK
import CocoaLumberjack

class OfferViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var lowBidPriceOutlet: UILabel!
    @IBOutlet weak var highBidPriceOutlet: UILabel!
    @IBOutlet weak var offerPriceOutlet: UILabel!
    @IBOutlet weak var currentTimerValueOutlet: UILabel!
    
    var userBid: Bid! // strong reference
    
    let ACTIVITY_INDICATOR_TAG: Int = 1

    var offerTimer = NSTimer()
    
    static let OFFER_TIMER_INTERVAL = 1.0
    static let OFFER_TIMER_EXPIRE_PERIOD = 25.0 // 25 seconds
    static let OFFER_TIMER_EXPIRE_MSG_TITLE = "Time expired."
    static let OFFER_TIMER_EXPIRE_MSG_CONTENT = "Reason: You were given 30 seconds to respond to the ride request."
    
    var timerCount: NSTimeInterval = 0.0
    var timerStart: NSTimeInterval!
    
    var savedBgTimestamp: NSDate?

    // MARK: Setup Functions
    func setupUI () {
        
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
        lowBidPriceOutlet.text = String(userBid.bidLow)
        highBidPriceOutlet.text = String(userBid.bidHigh)
        currentTimerValueOutlet.text = String(Int(timerStart))
        
        DDLogVerbose("TimerStart: \(timerStart)")

        startOfferTimer()
        
        BidState.sharedInstance().setOngoingBid(userBid)
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

    // MARK: Actions
    
    @IBAction func acceptRequestAction(sender: UIButton) {
        
        DDLogInfo("Called: \(self.offerPriceOutlet.text)")
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                Util.enableActivityIndicator(self.view, tag: 0)
                
                let client: BAAClient = BAAClient.sharedClient()
                
                client.createOffer(
                    self.userBid.id,
                    offerPrice: Int(self.offerPriceOutlet.text!),
                    completion: {(success, error) -> Void in

                    // diable the loading activity indicator
                    Util.disableActivityIndicator(self.view, tag: self.ACTIVITY_INDICATOR_TAG)
                    self.stopOfferTimer()

                    if (error == nil) {
                        DDLogVerbose("created offer \(success)")
                        self.performSegueWithIdentifier("offerSentSegue", sender: nil)
                    }
                    else {
                        errorBlock(success, error)
                    }
                })
        })
    }
    
    @IBAction func declineRequestAction(sender: UIButton) {
        
    }
    
    @IBAction func incrementOfferPriceAction(sender: AnyObject) {
        offerPriceOutlet.text = String(Int(offerPriceOutlet.text!)! + 1)
    }
    
    @IBAction func decrementOfferPriceAction(sender: AnyObject) {
        if (Int(offerPriceOutlet.text!) != 0) {
            offerPriceOutlet.text = String(Int(offerPriceOutlet.text!)! - 1)
        }
    }
    
    // MARK: Helpers
    
    func startOfferTimer() {
        offerTimer = NSTimer.scheduledTimerWithTimeInterval(OfferViewController.OFFER_TIMER_INTERVAL,
                                                            target: self,
                                                            selector: #selector(OfferViewController.updateTimer),
                                                            userInfo: nil,
                                                            repeats: true)
    }
    
    func stopOfferTimer() {
        offerTimer.invalidate()
    }
    
    func saveOfferTimer () {
        DDLogVerbose("Called")
        
        // if there is an active bid, save the current time
        if (BidState.sharedInstance().isOngoingBid()) {
            let curTime = NSDate()
            DDLogDebug("Setting bgtime \(curTime))")
            savedBgTimestamp = curTime
        }
    }
    
    func restoreOfferTimer () {
        DDLogVerbose("Called")
        
        if (BidState.sharedInstance().isOngoingBid()) {

            if let appBackgroundedTime = savedBgTimestamp {

                let elapsedTime = NSTimeInterval(Int(Util.diffFromCurTime(appBackgroundedTime))) // seconds

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
    
    func updateTimer() {

        // increment the timer count
        timerCount += OfferViewController.OFFER_TIMER_INTERVAL
        
        // if the counter reached MAX_TIME, dismiss the offerController, show the error message and take the driver back
        if (timerCount > timerStart) {
            
            DDLogVerbose("Resetting the bidState in updateTimer")
            
            stopOfferTimer()
            
            // delete the saved state bid
            BidState.sharedInstance().resetOngoingBid()

            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

            if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
 
                // find the DriverOnlineViewController and pop till that
                for viewController: UIViewController in mmnvc.viewControllers {
                    
                    if (viewController is DriverOnlineViewController) {
                        
                        let driverOnlineController: DriverOnlineViewController = (viewController as! DriverOnlineViewController)
                        
                        // dismiss all view controllers till this view controller
                        driverOnlineController.dismissViewControllerAnimated(true, completion: nil)
                        
                        Util.displayAlertOnVC(driverOnlineController, title: OfferViewController.OFFER_TIMER_EXPIRE_MSG_TITLE,
                                          message: OfferViewController.OFFER_TIMER_EXPIRE_MSG_CONTENT)
                    }
                }
            }
            return
        }
        
        // update the Timer label
        currentTimerValueOutlet.text = String(Int(timerStart - timerCount))
    }
}
