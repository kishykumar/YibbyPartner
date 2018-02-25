//
//  RideEndViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/10/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaLumberjack
import BaasBoxSDK
import GoogleMaps
import Cosmos
import AMPopTip
import ObjectMapper

class RideEndViewController: BaseYibbyViewController {

    // MARK: Properties

    @IBOutlet weak var riderImageViewOutlet: UIImageView!
    
    @IBOutlet var rideDateLbl: UILabel!
    @IBOutlet var riderNameLabelOutlet: UILabel!
    
    @IBOutlet weak var rideFareLabel: UILabel!
    @IBOutlet var finishBtn: UIButton!
    @IBOutlet weak var moreInfoButtonOutlet: UIButton!
    
    @IBOutlet weak var innerContentViewOutlet: UIView!
    @IBOutlet weak var ratingViewOutlet: CosmosView!
    @IBOutlet weak var tripDestinationMapViewOutlet: GMSMapView!
    
    @IBOutlet weak var milesDriverLabelOutlet: UILabel!
    @IBOutlet weak var tripDurationLabelOutlet: UILabel!
    
    var popTip = PopTip()

    // MARK: Actions
    
    @IBAction func onTipViewClick(_ sender: UIButton) {
        popTip.show(text: "Earning before tip", direction: .right, maxWidth: 200, in: innerContentViewOutlet, from: moreInfoButtonOutlet.frame)
    }
    
    @IBAction func rideFinishAction(_ sender: AnyObject) {
        let rating = String(ratingViewOutlet.rating)
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            
            let reviewDict = ["bidId": YBClient.sharedInstance().bid!.id!,
                              "feedback": "Hello I am here",
                              "rating": rating]
            
            client.postReview(BAASBOX_DRIVER_STRING, jsonBody: reviewDict, completion:{(success, error) -> Void in
                if (success != nil) {
                    DDLogVerbose("Review success: \(String(describing: success))")
                    YBClient.sharedInstance().bid = nil

                    client.syncClient(BAASBOX_DRIVER_STRING, bidId: nil, completion: { (success, error) -> Void in
                        
                        if let success = success {
                            let syncModel = Mapper<YBSync>().map(JSONObject: success)
                            if let syncData = syncModel {
                                
                                DDLogVerbose("syncApp syncdata for no bid: ")
                                dump(syncData)
                                
                                // Sync the local client
                                YBClient.sharedInstance().syncClient(syncData)

                                AlertUtil.displayAlert("Done with the ride!",
                                                       message: "Now let's take another one.",
                                                       completionBlock: {() -> Void in
                                                        
                                                        self.performSegue(withIdentifier: "unwindToMainViewController1", sender: self)
                                })
                            }
                        } else {
                            DDLogVerbose("Sync failed: \(String(describing: error))")
                            errorBlock(success, error)
                        }
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    })
                }
                else {
                    DDLogVerbose("Review failed: \(String(describing: error))")
                    errorBlock(success, error)
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                }
            })
        })
    }
    
    // MARK: Setup functions
    
    func setupUI() {
        setupMenuButton()
        
        rideFareLabel.textColor = UIColor.darkGray
        
        riderImageViewOutlet.layer.borderColor = UIColor.borderColor().cgColor
        riderImageViewOutlet.layer.borderWidth = 2.0
        riderImageViewOutlet.layer.cornerRadius = 25
        riderImageViewOutlet.clipsToBounds = true
        
        finishBtn.layer.cornerRadius = 7
        
        innerContentViewOutlet.layer.shadowOpacity = 0.50
        innerContentViewOutlet.layer.shadowRadius = 5.0
        innerContentViewOutlet.layer.shadowColor = UIColor.gray.cgColor
        innerContentViewOutlet.layer.shadowOffset = CGSize.zero
        
        popTip.bubbleColor = .clear
        popTip.textColor = .lightGray
        popTip.borderWidth = 1.0
        popTip.borderColor = .lightGray
        popTip.font = UIFont.systemFont(ofSize: 12)
        
        popTip.entranceAnimation = .none
        popTip.exitAnimation = .none
        
        tripDestinationMapViewOutlet.isUserInteractionEnabled = false
        tripDestinationMapViewOutlet.layer.borderWidth = 2.0
        tripDestinationMapViewOutlet.layer.borderColor = UIColor.borderColor().cgColor
        
        if let ride = YBClient.sharedInstance().ride {
            DDLogVerbose("KKDBG_rideEnd ride: \(ride)")
            dump(ride)
            
            let rideFareInt = Int(ride.fare!)
            rideFareLabel.text = "$\(rideFareInt)"
            
            if let rideISODateTime = ride.datetime, let rideDate = TimeUtil.getDateFromISOTime(rideISODateTime) {
                let prettyDate = TimeUtil.prettyPrintDate1(rideDate)
                rideDateLbl.text = prettyDate
            }
            
            if let rideMiles = ride.miles {
                milesDriverLabelOutlet.text = "\(rideMiles) miles"
            }
            
            if let rideDuration = ride.rideTime {
                milesDriverLabelOutlet.text = "\(rideDuration) mins"
            }
            
            if let pickupCoordinate = ride.pickupLocation?.coordinate(),
               let dropoffCoordinate = ride.dropoffLocation?.coordinate() {
                
                let pumarker = GMSMarker(position: pickupCoordinate)
                pumarker.icon = UIImage(named: "famarker_green")
                pumarker.map = tripDestinationMapViewOutlet
                
                let domarker = GMSMarker(position: dropoffCoordinate)
                domarker.icon = UIImage(named: "famarker_red")
                domarker.map = tripDestinationMapViewOutlet
            
                let bounds = GMSCoordinateBounds(coordinate: pickupCoordinate, coordinate: dropoffCoordinate)
                let insets = UIEdgeInsets(top: 10.0 + (domarker.icon?.size.height)!,
                                          left: 20.0,
                                          bottom: 10.0,
                                          right: 20.0)
                
                let update = GMSCameraUpdate.fit(bounds, with: insets)
                tripDestinationMapViewOutlet.moveCamera(update)
            }
            
            if let myRider = ride.rider {
                
                if let riderFirstName = myRider.firstName {
                    riderNameLabelOutlet.text = riderFirstName
                }
                
                if let riderProfilePic = myRider.profilePictureFileId {
                    if (riderProfilePic != "") {
                        if let imageUrl  = BAAFile.getCompleteURL(withToken: riderProfilePic) {
                            riderImageViewOutlet.pin_setImage(from: imageUrl)
                        }
                    }
                }
            }
        } else {
            DDLogError("KKDBG_rideEnd: no ride!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
