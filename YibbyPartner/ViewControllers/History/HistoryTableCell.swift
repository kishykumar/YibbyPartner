//
//  HistoryTableCell.swift
//  Yibby
//
//  Created by Kishy Kumar on 6/16/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import BaasBoxSDK

class HistoryTableCell : UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var tripGMSMapViewOutlet: GMSMapView!
    @IBOutlet weak var riderImageViewOutlet: UIImageView!
    @IBOutlet weak var dateTimeLabelOutlet: UILabel!
    @IBOutlet weak var riderNameLabelOutlet: UILabel!
    @IBOutlet weak var ridePriceLabelOutlet: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var myTrip: Ride!
    var myViewController: HistoryViewController!

    // MARK: - Setup
    func configure(_ ride: Ride) {
        
        riderImageViewOutlet.layer.borderColor = UIColor.grey5().cgColor
        riderImageViewOutlet.layer.borderWidth = 1.0
        riderImageViewOutlet.layer.cornerRadius = riderImageViewOutlet.frame.size.width/2

        self.riderNameLabelOutlet.text = ride.rider?.firstName
        
        if let rideISODateTime = ride.datetime, let rideDate = TimeUtil.getDateFromISOTime(rideISODateTime) {
            let prettyDate = TimeUtil.prettyPrintDate1(rideDate)
            self.dateTimeLabelOutlet.text = prettyDate
            self.dateTimeLabelOutlet.text = prettyDate
        }
        
        if let tip = ride.tip, let totalFare = ride.fare {
            self.ridePriceLabelOutlet.text = "$\(totalFare + tip)"
        }
        
        self.tripGMSMapViewOutlet.clear()
        self.tripGMSMapViewOutlet.isUserInteractionEnabled = false
        self.tripGMSMapViewOutlet.layer.borderWidth = 1
        self.tripGMSMapViewOutlet.layer.borderColor = UIColor.greyC().cgColor
        
        if let dropoffCoordinate = ride.dropoffLocation?.coordinate(),
            let pickupCoordinate = ride.pickupLocation?.coordinate() {
            
            // Markers for gmsMapViewOutlet
            let domarker = GMSMarker(position: dropoffCoordinate)
            domarker.icon = UIImage(named: "famarker_green")
            domarker.map = self.tripGMSMapViewOutlet
            
            let pumarker = GMSMarker(position: pickupCoordinate)
            pumarker.icon = UIImage(named: "famarker_red")
            pumarker.map = self.tripGMSMapViewOutlet
            
            adjustGMSCameraFocus(mapView: self.tripGMSMapViewOutlet, pickupMarker: pumarker, dropoffMarker: domarker)
        }
        
        if let profilePictureFileId = ride.rider?.profilePictureFileId {
            setPicture(imageView: self.riderImageViewOutlet, ride: ride, fileId: profilePictureFileId)
        }
    }
    
    override func awakeFromNib() {
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1.0
        containerView.layer.masksToBounds = true
        
        containerView.layer.borderColor = UIColor.borderColor()
            .cgColor
        
        super.awakeFromNib()
    }
    
    // MARK: - Helpers
    
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
