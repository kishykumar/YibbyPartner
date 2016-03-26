//
//  OfferViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/6/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import BaasBoxSDK

class OfferViewController: UIViewController {

    @IBOutlet weak var lowBidPriceOutlet: UILabel!
    @IBOutlet weak var highBidPriceOutlet: UILabel!
    @IBOutlet weak var offerPriceOutlet: UILabel!
    
    var userBid: Bid?
    let ACTIVITY_INDICATOR_TAG: Int = 1

    func setupUI () {
        
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // Do any additional setup after loading the view.
        lowBidPriceOutlet.text = String(userBid!.bidLow)
        highBidPriceOutlet.text = String(userBid!.bidHigh)
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
        
        // enable the loading activity indicator
        Util.enableActivityIndicator(self.view, tag: ACTIVITY_INDICATOR_TAG)
        
        let client: BAAClient = BAAClient.sharedClient()
        client.createOffer(userBid!.id, offerPrice: Int(offerPriceOutlet.text!), completion: {(success, error) -> Void in
            
            // diable the loading activity indicator
            Util.disableActivityIndicator(self.view, tag: self.ACTIVITY_INDICATOR_TAG)
            if (error == nil) {
                print("created offer \(success)")
                self.performSegueWithIdentifier("offerSentSegue", sender: nil)
            }
            else {
                print("error creating bid \(error)")
                // check if error is 401 (authentication) and re-authenticate
                
            }
            
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
}
