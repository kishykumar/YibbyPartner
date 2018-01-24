//
//  RideDetailViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 6/17/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

// TODO: Remove 'import BaasBoxSDK' and BAAFile references

import UIKit
import BaasBoxSDK
import GoogleMaps
import Font_Awesome_Swift

class RideDetailViewController: BaseYibbyViewController {

    // MARK: - Properties
    var ride: Ride!             // we need a strong reference as the ride should not be nil
    
    @IBOutlet weak var dateAndTimeLabelOutlet: UILabel!
    @IBOutlet weak var riderImageViewOutlet: UIImageView!
    @IBOutlet weak var carImageViewOutlet: UIImageView!
    @IBOutlet weak var pickupTextFieldOutlet: UITextField!
    @IBOutlet weak var dropoffTextFieldOutlet: UITextField!
    @IBOutlet weak var distanceLabelOutlet: UILabel!
    @IBOutlet weak var tripDurationLabelOutlet: UILabel!
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    @IBOutlet weak var ridePriceLabelOutlet: UILabel!
    @IBOutlet weak var tipLabelOutlet: UILabel!
    @IBOutlet weak var totalFareLabelOutlet: UILabel!
    
    @IBOutlet weak var lostStolenItemButtonOutlet: UIButton!
    @IBOutlet weak var fareRideIssueButtonOutlet: UIButton!
    @IBOutlet weak var otherIssueButtonOutlet: UIButton!
    
    // MARK: - Setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configure()
        // Do any additional setup after loading the view.
        
    }

    private func configure() {
        
        if let rideISODateTime = ride.datetime, let rideDate = TimeUtil.getDateFromISOTime(rideISODateTime) {
            let prettyDate = TimeUtil.prettyPrintDate1(rideDate)
            self.dateAndTimeLabelOutlet.text = prettyDate
        }
        
        self.pickupTextFieldOutlet.text = ride.pickupLocation?.name
        self.dropoffTextFieldOutlet.text = ride.dropoffLocation?.name
        
        var ridePrice: Float = 0.00
        var tip: Float = 0.00
        
        if let rp = ride.fare {
            ridePrice = rp
        }
        
        if let tp = ride.tip {
            tip = tp
        }
        
        self.ridePriceLabelOutlet.text = "$\(ridePrice)"
        self.tipLabelOutlet.text = "$\(tip)"
        self.totalFareLabelOutlet.text = "$\(ridePrice + tip)"
        
        if let dropoffCoordinate = ride.dropoffLocation?.coordinate(),
            let pickupCoordinate = ride.pickupLocation?.coordinate() {
            
            // Markers for gmsMapViewOutlet
            
            let domarker = GMSMarker(position: dropoffCoordinate)
            domarker.icon = UIImage(named: "famarker_green")
            domarker.map = self.gmsMapViewOutlet
            
            let pumarker = GMSMarker(position: pickupCoordinate)
            pumarker.icon = UIImage(named: "famarker_red")
            pumarker.map = self.gmsMapViewOutlet
            
            adjustGMSCameraFocus(mapView: self.gmsMapViewOutlet, pickupMarker: pumarker, dropoffMarker: domarker)
        }
        
        if let profilePictureFileId = ride.rider?.profilePictureFileId {
            setPicture(imageView: self.riderImageViewOutlet, ride: ride, fileId: profilePictureFileId)
        }
        
        if let vehiclePictureFileId = ride.vehicle?.vehiclePictureFileId {
            setPicture(imageView: self.carImageViewOutlet, ride: ride, fileId: vehiclePictureFileId)
        }
        
        if let milesTravelled = ride.miles {
            self.distanceLabelOutlet.text = "\(String(describing: milesTravelled)) miles"
        }
        
        if let rideTime = ride.rideTime {
            self.tripDurationLabelOutlet.text = "\(String(describing: rideTime)) mins"
        }
    }
    
    private func setupUI() {
        setupBackButton()
        
        riderImageViewOutlet.layer.borderColor = UIColor.borderColor().cgColor
        riderImageViewOutlet.layer.borderWidth = 1.0
        riderImageViewOutlet.layer.cornerRadius = 20
        riderImageViewOutlet.layer.shadowOpacity = 0.5
        riderImageViewOutlet.layer.shadowRadius = 2
        riderImageViewOutlet.layer.shadowColor = UIColor.gray.cgColor
        
        carImageViewOutlet.layer.borderColor = UIColor.borderColor().cgColor
        carImageViewOutlet.layer.borderWidth = 1.0
        carImageViewOutlet.layer.cornerRadius = carImageViewOutlet.frame.size.height/2-7
        
        pickupTextFieldOutlet.layer.borderColor = UIColor.borderColor().cgColor
        pickupTextFieldOutlet.layer.borderWidth = 1.0
        pickupTextFieldOutlet.layer.cornerRadius = 7
        pickupTextFieldOutlet.setLeftViewFAIcon(icon: .FAMapMarker, leftViewMode: .always, textColor: .greenD1(), backgroundColor: .clear, size: nil)
        
        dropoffTextFieldOutlet.layer.borderColor = UIColor.borderColor().cgColor
        dropoffTextFieldOutlet.layer.borderWidth = 1.0
        dropoffTextFieldOutlet.layer.cornerRadius = 7
        dropoffTextFieldOutlet.setLeftViewFAIcon(icon: .FAMapMarker, leftViewMode: .always, textColor: .red, backgroundColor: .clear, size: nil)
        
        gmsMapViewOutlet.clear()
        gmsMapViewOutlet.isUserInteractionEnabled = false
        gmsMapViewOutlet.layer.borderWidth = 1
        gmsMapViewOutlet.layer.borderColor = UIColor.greyC().cgColor
        
        lostStolenItemButtonOutlet.layer.shadowOpacity = 0.5
        lostStolenItemButtonOutlet.layer.shadowRadius = 2
        lostStolenItemButtonOutlet.layer.shadowColor = UIColor.gray.cgColor
        lostStolenItemButtonOutlet.layer.shadowOffset = CGSize(width: -2, height: 0)
        
        fareRideIssueButtonOutlet.layer.shadowOpacity = 0.5
        fareRideIssueButtonOutlet.layer.shadowRadius = 2
        fareRideIssueButtonOutlet.layer.shadowColor = UIColor.gray.cgColor
        fareRideIssueButtonOutlet.layer.shadowOffset = CGSize(width: -2, height: -1)
        
        otherIssueButtonOutlet.layer.shadowOpacity = 0.5
        otherIssueButtonOutlet.layer.shadowRadius = 2
        otherIssueButtonOutlet.layer.shadowColor = UIColor.gray.cgColor
        otherIssueButtonOutlet.layer.shadowOffset = CGSize(width: -2, height: -1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - Helper functions

    fileprivate func adjustGMSCameraFocus(mapView: GMSMapView, pickupMarker: GMSMarker, dropoffMarker: GMSMarker) {
        
        let bounds = GMSCoordinateBounds(coordinate: (pickupMarker.position),
                                         coordinate: (dropoffMarker.position))
        
        let insets = UIEdgeInsets(top: 50.0,
                                  left: 10.0,
                                  bottom: 20.0,
                                  right: 10.0)
        
        let update = GMSCameraUpdate.fit(bounds, with: insets)
        mapView.moveCamera(update)
    }
    
    
    fileprivate func setPicture(imageView: UIImageView, ride: Ride, fileId: String) {
        
        if (fileId == "") {
            return;
        }
        
        if let newUrl = BAAFile.getCompleteURL(withToken: fileId) {
            imageView.pin_setImage(from: newUrl)
        }
    }
}
