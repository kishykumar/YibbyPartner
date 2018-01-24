//
//  RideStartViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 6/6/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaLumberjack
import BaasBoxSDK
import BButton
import Spring

public enum RideViewControllerState: Int {
    case driverEnRoute = 0
    case driverArrived
    case rideStart
}

class RideStartViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    public var controllerState: RideViewControllerState = RideViewControllerState.driverEnRoute
    @IBOutlet weak var rideActionButton: BButton!
    @IBOutlet weak var startNavigationButton: BButton!
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    @IBOutlet weak var numPeopleLabelOutlet: UILabel!
    @IBOutlet weak var totalFareLabelOutlet: UILabel!
    @IBOutlet weak var riderDetailsViewOutlet: SpringView!
    @IBOutlet weak var riderFirstNameLabelOutlet: UILabel!
    @IBOutlet weak var riderRatingLabelOutlet: UILabel!
    @IBOutlet weak var riderProfilePictureOutlet: UIImageView!
    
    var bid: Bid!
    
//    var driverLocLatLng: CLLocationCoordinate2D?
//    var driverLocMarker: GMSMarker?
    
    var pickupMarker: GMSMarker?
    var dropoffMarker: GMSMarker?
    
    let GMS_DEFAULT_CAMERA_ZOOM: Float = 14.0

    let messageComposer = MessageComposer()

    var isRiderDetailsViewHidden = true
    
    // MARK: - Actions
    
    @IBAction func onCallButtonTap(_ sender: UIButton) {
        
        guard let ride = YBClient.sharedInstance().ride, let myRider = ride.rider else {
            
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
            
            return;
        }
        
        myRider.call()
    }

    @IBAction func sendTextMessageButtonTapped(_ sender: UIButton) {
        
        guard let ride = YBClient.sharedInstance().ride, let myRider = ride.rider, let phoneNumber = myRider.phoneNumber else {
            
            let errorAlert = UIAlertView(title: "Unexpected Error.", message: "We are working on resolving this error for you. Sincere apology for the inconvenience.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
            
            return;
        }
        
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(phoneNumber: phoneNumber)
            
            // Present the configured MFMessageComposeViewController instance
            self.present(messageComposeVC, animated: true, completion: nil)
            
        } else {
            let errorAlert = UIAlertView(title: "Unexpected Error.", message: "We are working on resolving this error for you. Sincere apology for the inconvenience.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
    @IBAction func onCenterMarkersViewClick(_ sender: UITapGestureRecognizer) {
        centerMarkers()
    }
    
    @IBAction func onStarButtonClick(_ sender: UIButton) {

        if (isRiderDetailsViewHidden) {
            riderDetailsViewOutlet.animation = "fadeIn"
            riderDetailsViewOutlet.animate()
            isRiderDetailsViewHidden = false
        } else {
            riderDetailsViewOutlet.animation = "fadeOut"
            riderDetailsViewOutlet.animate()
            isRiderDetailsViewHidden = true
        }
    }
    
    @IBAction func startNavAction(_ sender: AnyObject) {
        
        if (controllerState == RideViewControllerState.driverEnRoute) {
            MapService.sharedInstance().openDirectionsInGoogleMaps((self.bid.pickupLocation?.latitude)!,
                                                                   lng: (self.bid.pickupLocation?.longitude)!)
        } else if (controllerState == RideViewControllerState.rideStart) {
            MapService.sharedInstance().openDirectionsInGoogleMaps((self.bid.dropoffLocation?.latitude)!,
                                                                   lng: (self.bid.dropoffLocation?.longitude)!)
        }
    }
    
    @IBAction func onRideActionButtonClick(_ sender: AnyObject) {
        
        // Case 1: Clicked on Arrived at Pickup Point
        if (controllerState == RideViewControllerState.driverEnRoute) {
            
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    // Note: Dispatch after 5 seconds so that the driver doesn't accidently press the button twice.
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        client.arrived(atPickup: self.bid.id, completion: {(success, error) -> Void in
                            
                            if (error == nil) {
                            
                                self.controllerState = RideViewControllerState.driverArrived
                                self.rideActionButton.setTitle(InterfaceString.Ride.StartRide, for: .normal)

                                self.startNavigationButton.isHidden = true
                                
                                self.driverArrivedCallback()
                            }
                            else {
                                errorBlock(success, error)
                            }
                            
                            // diable the loading activity indicator
                            ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        })
                    })
            })
            
        }
        
        // Case 2: Driver clicks on Start the ride
        else if (controllerState == RideViewControllerState.driverArrived) {
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        client.startRide(self.bid.id, completion: {(success, error) -> Void in
                            
                            if (error == nil) {
                                
                                self.controllerState = RideViewControllerState.rideStart
                                self.rideActionButton.setTitle(InterfaceString.Ride.EndRide, for: .normal)
                                self.startNavigationButton.isHidden = false
                            }
                            else {
                                errorBlock(success, error)
                            }
                            
                            // diable the loading activity indicator
                            ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        })
                    })
            })
        }
        
        // Case 3: Driver clicks on End the Ride
        else if (controllerState == RideViewControllerState.rideStart) {
            
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in

                    // enable the loading activity indicator
                    ActivityIndicatorUtil.enableActivityIndicator(self.view)
                    
                    let client: BAAClient = BAAClient.shared()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        client.endRide(self.bid.id, completion: {(success, error) -> Void in
                            
                            if (error == nil) {
                                
                                let rideStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Ride, bundle: nil)

                                let rideEndViewController = rideStoryboard.instantiateViewController(withIdentifier: "RideEndViewControllerIdentifier") as! RideEndViewController

                                self.navigationController!.pushViewController(rideEndViewController, animated: true)
                                
                            }
                            else {
                                errorBlock(success, error)
                            }
                            
                            // diable the loading activity indicator
                            ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        })
                    })
            })
            
        }
    }
    
    // MARK: - Setup functions

    func initProperties() {
        self.bid = (YBClient.sharedInstance().bid)
    }
    
    func setupUI() {
        setupMenuButton()
        
        riderDetailsViewOutlet.animation = "fadeOut"
        riderDetailsViewOutlet.animate()

        riderProfilePictureOutlet.setRoundedWithBorder(self.view.tintColor)
        riderProfilePictureOutlet.addShadow()
        
        if let ride = YBClient.sharedInstance().ride {
            
            DDLogVerbose("KKDBG_ride:")
            dump(ride)

            if let fare = ride.fare {
                let fareInt = Int(fare)
                totalFareLabelOutlet.text = "$\(String(describing: fareInt))"
            }
            
            if let people = ride.people {
                //let fontSize = numPeopleLabelOutlet.font.pointSize
                //numPeopleLabelOutlet.font = UIFont(name: "FontAwesome", size: fontSize)
                numPeopleLabelOutlet.text = "\(String(describing: people)) \(String(format: "%C", 0xf0c0))"
            }
            
            if let myRider = ride.rider {
                
                // First Name
                riderFirstNameLabelOutlet.text = myRider.firstName
                
                // Rating
                if let rating = myRider.rating {
                    riderRatingLabelOutlet.text = "\(String(describing: rating)) \(String(format: "%C", 0xf005))"
                }
                
                // Profile pic
                if let riderProfilePic = myRider.profilePictureFileId {
                    if (riderProfilePic != "") {
                        if let imageUrl  = BAAFile.getCompleteURL(withToken: riderProfilePic) {
                            riderProfilePictureOutlet.pin_setImage(from: imageUrl)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setupMap () {
        gmsMapViewOutlet.isMyLocationEnabled = true
        
        // Very Important: DONT disable consume all gestures because it's needed for nav drawer with a map
        gmsMapViewOutlet.settings.consumesGesturesInView = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        riderDetailsViewOutlet.round(corners:  [.topLeft, .topRight], radius: 10.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
        setupMap()
        rideSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func rideSetup() {
        
        switch (self.controllerState) {
        case .driverEnRoute:

            rideActionButton.setTitle(InterfaceString.Ride.ArrivedAtPickup, for: .normal)

            self.startNavigationButton.isHidden = false
            
            // Add marker to the pickup location
            setPickupDetails(self.bid.pickupLocation!)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                if let curLocation = LocationService.sharedInstance().provideCurrentLocation() {
                    DispatchQueue.main.async {
                        self.adjustGMSCameraFocus(marker1: self.pickupMarker, driverLocation: curLocation.coordinate)
                    }
                }
            }
            
            break
            
        case .driverArrived:
            rideActionButton.setTitle(InterfaceString.Ride.StartRide, for: .normal)

            self.startNavigationButton.isHidden = true
            
            // Add marker to dropoff location
            self.setDropoffDetails(self.bid.dropoffLocation!)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                if let curLocation = LocationService.sharedInstance().provideCurrentLocation() {
                    DispatchQueue.main.async {
                        self.adjustGMSCameraFocus(marker1: self.dropoffMarker, driverLocation: curLocation.coordinate)
                    }
                }
            }
            
            break
            
        case .rideStart:
            rideActionButton.setTitle(InterfaceString.Ride.EndRide, for: .normal)

            self.startNavigationButton.isHidden = false

            
            // Add marker to dropoff location
            self.setDropoffDetails(self.bid.dropoffLocation!)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                if let curLocation = LocationService.sharedInstance().provideCurrentLocation() {
                    DispatchQueue.main.async {
                        self.adjustGMSCameraFocus(marker1: self.dropoffMarker, driverLocation: curLocation.coordinate)
                    }
                }
            }
            
            break
        }
    }
    
    // MARK: - Helper functions
    
    fileprivate func centerMarkers() {
        let driverLocation = gmsMapViewOutlet.myLocation?.coordinate
        adjustGMSCameraFocus(marker1: pickupMarker ?? dropoffMarker, driverLocation: driverLocation)
    }
    
    fileprivate func driverArrivedCallback() {
        let driverLocation = gmsMapViewOutlet.myLocation?.coordinate
        
        clearPickupDetails()
        
        setDropoffDetails(bid.dropoffLocation!)
        
        adjustGMSCameraFocus(marker1: dropoffMarker, driverLocation: driverLocation)
    }
    
    fileprivate func clearPickupDetails() {
        pickupMarker?.map = nil
        pickupMarker = nil
    }
    
    fileprivate func setPickupDetails (_ location: YBLocation) {
        
        pickupMarker?.map = nil
        
        let pumarker = GMSMarker(position: location.coordinate())
        pumarker.map = gmsMapViewOutlet
        pumarker.icon = YibbyMapMarker.annotationImageWithMarker(pumarker,
                                                                 title: location.name!,
                                                                 type: .pickup)
        
        pickupMarker = pumarker
    }
    
    fileprivate func setDropoffDetails (_ location: YBLocation) {
        
        dropoffMarker?.map = nil
        
        let domarker = GMSMarker(position: location.coordinate())
        domarker.map = gmsMapViewOutlet
        
        domarker.icon = YibbyMapMarker.annotationImageWithMarker(domarker,
                                                                 title: location.name!,
                                                                 type: .dropoff)
        
        dropoffMarker = domarker
    }
    
    fileprivate func adjustGMSCameraFocus(marker1: GMSMarker?, driverLocation: CLLocationCoordinate2D?) {
        
        guard let marker1 = marker1 else {
            
            if let driverLocation = driverLocation {
                let update = GMSCameraUpdate.setTarget((driverLocation),
                                                       zoom: GMS_DEFAULT_CAMERA_ZOOM)
                gmsMapViewOutlet.moveCamera(update)
            }
            return
        }
        
        guard let driverLoc = driverLocation else {
            
            let update = GMSCameraUpdate.setTarget((marker1.position),
                                                   zoom: GMS_DEFAULT_CAMERA_ZOOM)
            gmsMapViewOutlet.moveCamera(update)
            return
        }
        
        let heightInset = marker1.icon?.size.height
        let widthInset = marker1.icon?.size.width
        
        let startNavigationButtonRelativeOrigin: CGPoint =
            (startNavigationButton.superview?.convert(startNavigationButton.frame.origin,
                                                 to: gmsMapViewOutlet))!
        
        let bounds = GMSCoordinateBounds(coordinate: marker1.position, coordinate: driverLoc)
        let insets = UIEdgeInsets(top: startNavigationButtonRelativeOrigin.y + startNavigationButton.bounds.height + (heightInset!) + 10.0,
                                  left: (widthInset! / 2) + 20.0,
                                  bottom: 20.0,
                                  right: (widthInset! / 2) + 20.0)
        
        let update = GMSCameraUpdate.fit(bounds, with: insets)
        gmsMapViewOutlet.moveCamera(update)
        
    }
}
