//
//  SettingsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 2/19/16.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import CocoaLumberjack
import BaasBoxSDK
import ObjectMapper
import ImagePicker
import Lightbox
import BButton
import SwiftValidator

public struct ProfileNotifications {
    static let profilePictureUpdated = TypedNotification<String>(name: "com.Yibby.Profile.updateProfilePicture")
}

class SettingsViewController: BaseYibbyViewController, UITextFieldDelegate, ValidationDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var emailAddress: YBTextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var profileImageViewOutlet: SwiftyAvatar!
    @IBOutlet var VW: YBBorderedUIView!
    @IBOutlet var firstNameLbl: UILabel!
    @IBOutlet var lastNameLbl: UILabel!
    @IBOutlet var emailEditBtnOutlet: UIButton!
    
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    @IBOutlet weak var mapSelectionSegmentControl: UISegmentedControl!
    @IBOutlet weak var vehicleImageViewOutlet: UIImageView!
    @IBOutlet weak var changeVehicleButtonOutlet: UIButton!
    @IBOutlet weak var vehicleMakeModelLabelOutlet: YibbyPaddingLabel!
    @IBOutlet weak var licensePlateLabelOutlet: YibbyPaddingLabel!
    @IBOutlet weak var vehicleDetailsViewOutlet: YBBorderedUIView!
    
    
    var emailEditInProgress: Bool = false
    
    let imagePickerController: ImagePickerController = ImagePickerController()
    
    let validator: Validator = Validator()
    
    // MARK: - Actions
    
    @IBAction func onProfileImageClick(_ sender: UITapGestureRecognizer) {
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onChangeVehicleClick(_ sender: UIButton) {
        // TODO: Fill
    }
    
    @IBAction func emailEditBtnAction(_ sender: Any) {
        
        if (emailEditInProgress == true) {
            
            self.validator.validate(self)
            
        } else {
            
            emailEditBtnOutlet.setFAIcon(icon: .FACheckCircle, forState: .normal)
            emailEditBtnOutlet.setTitleColor(UIColor.appDarkGreen1(), for: .normal)
            emailEditBtnOutlet.layer.borderWidth = 0.0
            
            emailAddress.isUserInteractionEnabled = true
            emailAddress.becomeFirstResponder()
            emailAddress.layer.borderWidth = 1.0
            emailAddress.layer.cornerRadius = 7.0
            emailAddress.layer.borderColor = UIColor.appDarkGreen1().cgColor
            
            emailEditInProgress = true
        }
    }
    
    // MARK: - Setup Functions
    
    func setupValidator() {
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.appDarkGreen1().cgColor
            }
        }, error:{ (validationError) -> Void in
            
        })
        
        validator.registerField(self.emailAddress,
                                errorLabel: errorLabelOutlet,
                                rules: [RequiredRule(message: "Email Address is required"), EmailRule()])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupDelegates()
        setupImagePicker()
        setupValidator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: bug in ImagePicker: they remove the status bar :(
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    func setupImagePicker() {
        self.imagePickerController.imageLimit = 1
    }
    
    func setupDelegates() {
        imagePickerController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupUI() {
        
        setupBackButton()
        
        VW.layer.borderColor = UIColor.appDarkGreen1().cgColor
        vehicleDetailsViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        firstNameLbl.layer.borderColor = UIColor.appDarkGreen1().cgColor
        lastNameLbl.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        vehicleMakeModelLabelOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        licensePlateLabelOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        emailEditBtnOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        emailEditBtnOutlet.layer.borderWidth = 1.0
        emailEditBtnOutlet.layer.cornerRadius = 7.0
        
        // Set rounded profile pic
        profileImageViewOutlet.setRoundedWithBorder(UIColor.appDarkGreen1())
        
        // Round the vehicle image
        vehicleImageViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        vehicleImageViewOutlet.layer.borderWidth = 1.0
        vehicleImageViewOutlet.layer.cornerRadius = 20.0
        
        //Set segmented control to the map used for navigation
        setMapSelectionSegmentedIndex()
        
        emailAddress.removeFormatting()
        
        if let profile = YBClient.sharedInstance().profile {
            self.applyProfileModel(profile)
            setProfilePicture()
        }
    }
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        
        emailEditBtnOutlet.setFAIcon(icon: .FAWrench, forState: .normal)
        emailEditBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        emailEditBtnOutlet.layer.borderWidth = 1.0
        
        emailAddress.isUserInteractionEnabled = false
        emailAddress.resignFirstResponder()
        emailAddress.removeFormatting()
        
        if (emailAddress.text?.isEqual(YBClient.sharedInstance().profile?.personal?.emailId))! {
            
        }
        else {
            updateEmail()
        }
        
        emailEditInProgress = false
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        
        let (_, validationError): (Validatable, ValidationError) = errors[0]
        
        emailAddress.layer.borderColor = UIColor.red.cgColor
        validationError.errorLabel?.isHidden = false
        validationError.errorLabel?.text = validationError.errorMessage
    }
    
    // MARK: - Helpers
    
    func setProfilePicture() {
        
        let dl = YBClient.sharedInstance().profile!.driverLicense!
        let name = "\(dl.firstName!) \(dl.lastName!)"
        
        profileImageViewOutlet.setImageForName(string: name,
                                               backgroundColor: UIColor.appDarkGreen1(),
                                               circular: true,
                                               textAttributes: nil)
        
        if let profilePic = YBClient.sharedInstance().profile?.personal?.profilePicture {
            if (profilePic != "") {
                if let imageUrl  = BAAFile.getCompleteURL(withToken: profilePic) {
                    
                    profileImageViewOutlet.pin_setImage(from: imageUrl)
                }
            }
        }
    }
    
    @available(*, deprecated)
    func getProfile() {
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            
            client.getProfile(BAASBOX_DRIVER_STRING, completion:{(success, error) -> Void in
                
                ActivityIndicatorUtil.disableActivityIndicator(self.view)
                
                DDLogVerbose("getProfile data: \(String(describing: success))")
                
                if let success = success {
                    let profileModel = Mapper<YBProfile>().map(JSONObject: success)
                    
                    if let profile = profileModel {
                        self.applyProfileModel(profile)
                    }
                    else {
                        AlertUtil.displayAlert("Error in Fetching User Profile", message: error?.localizedDescription ?? "")
                        DDLogVerbose("getProfile failed1: \(String(describing: success))")
                    }
                    
                } else {
                    // TODO: Show the alert with error
                    AlertUtil.displayAlert("Error in Fetching User Profile", message: error?.localizedDescription ?? "")
                    DDLogVerbose("getProfile failed2: \(String(describing: error))")
                }
            })
        })
    }
    
    func updateEmail() {
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            
            let dictionary: [String: String] = ["email": emailAddress.text!]
            
            client.updateProfile(BAASBOX_DRIVER_STRING, jsonBody: dictionary, completion:{(success, error) -> Void in
                if let success = success {
                    let profileModel = Mapper<YBProfile>().map(JSONObject: success)
                    
                    if let profile = profileModel {
                        self.applyProfileModel(profile)
                    }
                    else {
                        AlertUtil.displayAlert("Error in Updating User Profile", message: error?.localizedDescription ?? "")
                        DDLogError("Error in updating Profile: \(String(describing: success))")
                    }
                }
                else {
                    AlertUtil.displayAlert("Error in Updating User Profile", message: error?.localizedDescription ?? "")
                    DDLogVerbose("updateProfile failed: \(String(describing: error))")
                }
                
                ActivityIndicatorUtil.disableActivityIndicator(self.view)
            })
        })
    }
    
    func applyProfileModel(_ profile: YBProfile) {
        
        // update the global profile object first
        YBClient.sharedInstance().profile = profile
        
        self.emailAddress.text = profile.personal?.emailId
        self.phoneNo.text = profile.personal?.phoneNumber?.toPhoneNumber()
        
        let firstName = profile.driverLicense?.firstName
        let lastName = profile.driverLicense?.lastName
        
        self.firstNameLbl.text = firstName!.uppercased()
        self.lastNameLbl.text = lastName!.uppercased()
        
        if let vehicle = profile.vehicle {
            
            if let vehiclePic = YBClient.sharedInstance().profile?.vehicle?.vehiclePictureFileId {
                if (vehiclePic != "") {
                    if let imageUrl  = BAAFile.getCompleteURL(withToken: vehiclePic) {
                        self.vehicleImageViewOutlet.pin_setImage(from: imageUrl)
                    }
                }
            }
            
            self.vehicleMakeModelLabelOutlet.text = "\(vehicle.make!) \(vehicle.model!)".capitalized
            self.licensePlateLabelOutlet.text = vehicle.licensePlate?.uppercased()
        }
        
        setProfilePicture()
    }
    
    func setMapSelectionSegmentedIndex(){
        let mapForNav = Defaults.getDefaultNavigationMap()
        switch mapForNav {
        case 0:
            mapSelectionSegmentControl.selectedSegmentIndex = 0
        case 1:
            mapSelectionSegmentControl.selectedSegmentIndex = 1
        case 2:
            mapSelectionSegmentControl.selectedSegmentIndex = 2
        default:
            mapSelectionSegmentControl.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func mapSelectionChanged(_ sender: UISegmentedControl) {
        switch mapSelectionSegmentControl.selectedSegmentIndex {
        case 0:
            Defaults.setDefaultNavigationMap(value: 0)
            DDLogVerbose("google maps selected")
        case 1:
            Defaults.setDefaultNavigationMap(value: 1)
             DDLogVerbose("apple maps selected")
        case 2:
            Defaults.setDefaultNavigationMap(value: 2)
             DDLogVerbose("waze maps selected")
        default:
            Defaults.setDefaultNavigationMap(value: 0)
             DDLogVerbose("google maps selected")
        }
    }
    
}

extension SettingsViewController: ImagePickerDelegate {
    
    public func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    public func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePickerController.present(lightbox, animated: true, completion: nil)
    }
    
    public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        guard images.count > 0 else { return }
        
        if let image = images.first {
            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            ImageService.sharedInstance().uploadImage(image,
              cacheKey: .profilePicture,
              success: { (url, fileId) in
                
                WebInterface.makeWebRequestAndHandleError(
                    self,
                    webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                        
                    let client: BAAClient = BAAClient.shared()

                    let dictionary = ["personal": ["profilePicture": fileId]]
                    client.updateProfile(BAASBOX_DRIVER_STRING, jsonBody: dictionary, completion:{(success, error) -> Void in
                        
                        if let success = success {
                            let profileModel = Mapper<YBProfile>().map(JSONObject: success)
                            
                            if let profile = profileModel {
                                self.applyProfileModel(profile)
                                
                                // update UI here
                                self.profileImageViewOutlet.image = image
                                
                                // post notification to update the profile picture in other view controllers
                                postNotification(ProfileNotifications.profilePictureUpdated, value: "")
                            }
                            else {
                                AlertUtil.displayAlert("Error in updating profile picture", message: error?.localizedDescription ?? "")
                                DDLogError("Error in updating profilepic: \(String(describing: success))")
                            }
                        }
                        else {
                            AlertUtil.displayAlert("Error in updating profile picture", message: error?.localizedDescription ?? "")
                            DDLogVerbose("addHomeDetails failed: \(String(describing: error))")
                        }
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    })
                })
            },
              failure: { error in
                
                DDLogError("Failure in uploading profile picture: \(error.description)")

                AlertUtil.displayAlert("Upload failed", message: error.localizedDescription)
                ActivityIndicatorUtil.disableActivityIndicator(self.view)
            })
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}



extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
    }
}
