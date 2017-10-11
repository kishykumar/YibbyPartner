//
//  HelpViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 4/5/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import BaasBoxSDK
import ObjectMapper

class HelpViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var containerViewUserImageOutlet: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var VW: UIView!
    @IBOutlet var VW1: UIView!
    
    @IBOutlet var lastTripTime: UILabel!
    @IBOutlet var lastTripPrice: UILabel!

    @IBOutlet weak var vehicleMakeModelLabelOutlet: UILabel!
    @IBOutlet var appVersionLbl: UILabel!
    
    var lastRide: Ride?

    // MARK: - Actions
    
    @IBAction func rideHistoryBtnAction(sender: AnyObject) {
        
        let historyStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.History, bundle: nil)

        let tripTableVC = historyStoryboard.instantiateViewController(withIdentifier: "HistoryViewControllerIdentifier") as! HistoryViewController
        _ = self.navigationController?.pushViewController(tripTableVC, animated: true)
    }
    
    @IBAction func helpCenterBtnAction(sender: AnyObject){
        let HelpCenterNVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        _ = self.navigationController?.pushViewController(HelpCenterNVC, animated: true)
    }
    
    @IBAction func legalBtnAction(sender: AnyObject) {
        let LegalVCNVC = self.storyboard?.instantiateViewController(withIdentifier: "LegalVC") as! LegalVC
        _ = self.navigationController?.pushViewController(LegalVCNVC, animated: true)
    }
    
    // MARK: - Setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
        self.perform(#selector(HelpViewController.loadLastRide), with:nil, afterDelay:0.0)
    }
    
    private func setupUI() {
        setupBackButton()
        
        VW.layer.borderColor = UIColor.borderColor().cgColor
        VW.layer.borderWidth = 1.0
        VW.layer.cornerRadius = 7
        
        VW1.layer.borderColor = UIColor.borderColor().cgColor
        VW1.layer.borderWidth = 1.0
        VW1.layer.cornerRadius = 7
        
        // Add shadow to container view and border to image view to achieve the UI effect
        // https://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow
        
        userImage.curvedViewWithBorder(20.0, borderColor: UIColor.white)
        containerViewUserImageOutlet.addShadow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helpers
    
    func setPicture(imageView: UIImageView, ride: Ride, fileId: String) {
        
        if (fileId == "") {
            return;
        }
        
        if let newUrl = BAAFile.getCompleteURL(withToken: fileId) {
            imageView.pin_setImage(from: newUrl)
        }
    }
    
    func updateLastRideUI() {
        
        if let ride = lastRide {
            
            lastTripPrice.text = "$\(ride.fare!)"
            
            if let rideISODateTime = ride.datetime, let rideDate = TimeUtil.getDateFromISOTime(rideISODateTime) {
                let prettyDate = TimeUtil.prettyPrintDate1(rideDate)
                lastTripTime.text = prettyDate
            }
            
            if let profilePictureFileId = ride.rider?.profilePictureFileId {
                setPicture(imageView: userImage, ride: ride, fileId: profilePictureFileId)
            }
            
//            if let vehicle = ride.vehicle {
//                vehicleMakeModelLabelOutlet.text = "\(vehicle.make!.capitalized) \(vehicle.model!.capitalized)"
//            }
        }
    }
    
    @objc fileprivate func loadLastRide() {
        
        ActivityIndicatorUtil.enableRegularActivityIndicator(self.VW)
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                let client: BAAClient = BAAClient.shared()
                
                client.getRides(BAASBOX_RIDER_STRING,
                    withParams: ["orderBy": "_creation_date desc", "recordsPerPage": 1,
                                 "page": 0],
                    completion: {(success, error) -> Void in
                        
                        if (error == nil && success != nil) {
                            
                            let loadedRides = Mapper<Ride>().mapArray(JSONObject: success)
                            
                            if let loadedRides = loadedRides {
                                
                                let numRidesToShow = loadedRides.count
                                
                                if numRidesToShow != 0 {
                                    
                                    assert(numRidesToShow == 1)
                                    self.lastRide = loadedRides[0]
                                    self.updateLastRideUI()
                                }
                            }
                        }
                        else {
                            errorBlock(success, error)
                        }
                        
                        ActivityIndicatorUtil.disableActivityIndicator(self.VW)
                })
        })
    }
}
