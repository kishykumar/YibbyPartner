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
import ObjectMapper

public enum RideViewControllerState: Int {
    case driverEnRoute = 0
    case driverArrived
    case rideStart
}

// The following enum values have to match the values on the webserver
public enum RideCancellationReason: Int {
    case driverPlansChanged = 4
    case driverEmergency = 5
}

class RideStartViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    public var controllerState: RideViewControllerState = RideViewControllerState.driverEnRoute
    @IBOutlet weak var rideActionButton: UIButton!
    @IBOutlet weak var startNavigationButton: UIButton!
    @IBOutlet weak var gmsMapViewOutlet: GMSMapView!
    @IBOutlet weak var numPeopleLabelOutlet: UILabel!
    @IBOutlet weak var totalFareLabelOutlet: UILabel!
    @IBOutlet weak var riderDetailsViewOutlet: SpringView!
    @IBOutlet weak var riderFirstNameLabelOutlet: UILabel!
    @IBOutlet weak var riderRatingLabelOutlet: UILabel!
    @IBOutlet weak var riderProfilePictureOutlet: SwiftyAvatar!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    var bid: Bid!
    
    var pickupMarker: GMSMarker?
    var dropoffMarker: GMSMarker?
    
    let GMS_DEFAULT_CAMERA_ZOOM: Float = 14.0
    

    let messageComposer = MessageComposer()

    var isRiderDetailsViewHidden = true
    
    fileprivate var rideCancelObserver: NotificationObserver?

    // MARK: - Actions
    
    @IBAction func onCancelRideClick(_ sender: UIButton) {
        
        let emergencyAction = UIAlertAction(title: InterfaceString.ActionSheet.EmergencyReason, style: .default) { _ in
            self.cancelRide(with: .driverEmergency)
        }
        
        let plansChangedAction = UIAlertAction(title: InterfaceString.ActionSheet.PlansChangedReason,
                                               style: .destructive) { _ in
            self.cancelRide(with: .driverPlansChanged)
        }
        
        let cancelAction = UIAlertAction(title: InterfaceString.Cancel, style: .cancel)
        
        let controller = UIAlertController(title: InterfaceString.ActionSheet.CancelReason,
                                           message: "Cancelling too many rides decreases your chance to get future rides.",
                                           preferredStyle: .actionSheet)
        
        for action in [emergencyAction, plansChangedAction, cancelAction] {
            controller.addAction(action)
        }
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func onCallButtonTap(_ sender: UIButton) {
        
        guard let ride = YBClient.sharedInstance().ride, let myRider = ride.rider else {
            AlertUtil.displayAlertOnVC(self, title: "Cannot make the call at this moment.", message: "")
            return;
        }
        
        myRider.call()
    }

    @IBAction func sendTextMessageButtonTapped(_ sender: UIButton) {
        
        guard let ride = YBClient.sharedInstance().ride, let myRider = ride.rider, let phoneNumber = myRider.phoneNumber else {
            AlertUtil.displayAlertOnVC(self, title: "Cannot Send Text Message at this moment.", message: "")
            return;
        }
        
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(phoneNumber: phoneNumber)
            
            // Present the configured MFMessageComposeViewController instance
            self.present(messageComposeVC, animated: true, completion: nil)
            
        } else {
            AlertUtil.displayAlertOnVC(self, title: "Cannot Send Text Message at this moment.", message: "")
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
        let mapForNavValue = Defaults.getDefaultNavigationMap()
        if (controllerState == RideViewControllerState.driverEnRoute) {
            startNavigation(mapForNavValue: mapForNavValue, lat: (self.bid.pickupLocation?.latitude)!, long: (self.bid.pickupLocation?.longitude)!)
            
        } else if (controllerState == RideViewControllerState.rideStart) {
            startNavigation(mapForNavValue: mapForNavValue, lat: (self.bid.dropoffLocation?.latitude)!, long: (self.bid.dropoffLocation?.longitude)!)
            
            //MapService.sharedInstance().openDirectionsInGoogleMaps((self.bid.dropoffLocation?.latitude)!,
                                                                   //lng: (self.bid.dropoffLocation?.longitude)!)
        }
    }
    
    @IBAction func onRideActionButtonClick(_ sender: AnyObject) {
        
        // Case 1: Clicked on  at Pickup Point
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
                            
                                YBClient.sharedInstance().status = .driverArrived
                                
                                self.controllerState = RideViewControllerState.driverArrived
                                self.rideActionButton.setTitle(InterfaceString.Ride.StartRide, for: .normal)

                                self.startNavigationButton.isHidden = true
                                self.cancelButtonOutlet.removeFromSuperview()
                                
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
                                
                                YBClient.sharedInstance().status = .rideStart
                                
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
                                
                                YBClient.sharedInstance().status = .rideEnd
                                
                                let rideModel = Mapper<Ride>().map(JSONObject: success)
                                
                                // Refresh the ride state from the response
                                YBClient.sharedInstance().ride = rideModel
                                
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
    
    func initProperties() {
        self.bid = (YBClient.sharedInstance().bid)
    }
    
    func setupUI() {
        setupMenuButton()
        
        riderDetailsViewOutlet.animation = "fadeOut"
        riderDetailsViewOutlet.animate()

        if let ride = YBClient.sharedInstance().ride {
            
            DDLogVerbose("KKDBG_ride:")
            dump(ride)

            if let fare = ride.bidPrice {
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
                riderProfilePictureOutlet.setImageForName(string: myRider.firstName!,
                                                          backgroundColor: UIColor.appDarkBlue1(),
                                                          circular: true,
                                                          textAttributes: nil)
                
                if let riderProfilePic = myRider.profilePictureFileId {
                    if (riderProfilePic != "") {
                        if let imageUrl  = BAAFile.getCompleteURL(withToken: riderProfilePic) {
                            riderProfilePictureOutlet.pin_setImage(from: imageUrl)
                            
                            riderProfilePictureOutlet.borderWidth = 2.0
                            riderProfilePictureOutlet.borderColor = self.view.tintColor
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
    
    deinit {
        DDLogVerbose("Fired deinit")
        removeNotificationObservers()
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
            self.cancelButtonOutlet.removeFromSuperview()
            
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
            self.cancelButtonOutlet.removeFromSuperview()
            
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
    
    // MARK: Notifications
    
    fileprivate func setupNotificationObservers() {
        
        DDLogVerbose("setup notifications observers")
        
        rideCancelObserver = NotificationObserver(notification: RideNotifications.rideCancelled) { [unowned self] ride in
            DDLogVerbose("NotificationObserver rideCancel: \(ride)")
            self.riderCancelledRideCallback()
        }
    }
    
    fileprivate func removeNotificationObservers() {
        DDLogVerbose("removing notifications observers")
        rideCancelObserver?.removeObserver()
    }
    
    // MARK: - Helper functions
    
    fileprivate func riderCancelledRideCallback() {
        
        YBClient.sharedInstance().bid = nil
        YBClient.sharedInstance().status = .online
        
        AlertUtil.displayAlertOnVC(self, title: "Unfortunately, your ride has been cancelled by the rider.",
                                   message: "You will be compensated according to our Terms & Conditions.",
                                   completionBlock: {() -> Void in
                                    
                                    // Trigger unwind segue to MainViewController
                                    self.performSegue(withIdentifier: "unwindToMainViewControllerFromRideStartViewController", sender: self)
        })
    }
    
    fileprivate func cancelRide(with reason: RideCancellationReason) {
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                ActivityIndicatorUtil.enableActivityIndicator(self.view, title: "Cancelling Ride")
                
                let client: BAAClient = BAAClient.shared()
                
                client.cancelDriverRide(YBClient.sharedInstance().bid?.id,
                                        cancelCode: reason.rawValue as NSNumber,
                                        completion: {(success, error) -> Void in
                                        
                                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                                        
                                        if (success != nil) {
                                            
                                            // Set the client state
                                            YBClient.sharedInstance().status = .online
                                            YBClient.sharedInstance().bid = nil
                                            
                                            AlertUtil.displayAlertOnVC(self, title: "Ride successfully cancelled",
                                                                       message: "Cancelling too many rides decreases your chance to get future rides.",
                                                                       completionBlock: {() -> Void in
                                                                        
                                                                        // Trigger unwind segue to MainViewController
                                                                        self.performSegue(withIdentifier: "unwindToMainViewControllerFromRideStartViewController", sender: self)
                                            })
                                            
                                        } else {
                                            DDLogVerbose("Ride Cancel failed: \(String(describing: error))")
                                            errorBlock(success, error)
                                        }
                })
        })
    }
    
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
        
        let bounds = GMSCoordinateBounds(coordinate: marker1.position, coordinate: driverLoc)
        let insets = UIEdgeInsets(top: (heightInset!) + 20.0,
                                  left: (widthInset! / 2) + 20.0,
                                  bottom: 20.0,
                                  right: (widthInset! / 2) + 20.0)
        
        let update = GMSCameraUpdate.fit(bounds, with: insets)
        gmsMapViewOutlet.moveCamera(update)
        
    }
    
    fileprivate func startNavigation(mapForNavValue:Int, lat:CLLocationDegrees, long:CLLocationDegrees){
        switch mapForNavValue{
        case 0:
            MapService.sharedInstance().openInGoogleMap(lat: lat, long: long)
        case 1:
            MapService.sharedInstance().openInAppleMap(lat: lat, long: long)
        case 2:
            MapService.sharedInstance().openInWaze(lat: lat, long: long)
        default:
            MapService.sharedInstance().openInGoogleMap(lat: lat, long: long)
        }
    }
    
}
