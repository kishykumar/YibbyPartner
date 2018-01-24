//
//  InsuranceViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CocoaLumberjack
import AIFlatSwitch
import ImagePicker
import Lightbox
import SwiftValidator

class InsuranceViewController: BaseYibbyViewController,
                               ValidationDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var uploadLicenseViewOutlet: YBUploadPictureView!
    @IBOutlet weak var uploadInsuranceViewOutlet: YBUploadPictureView!
    @IBOutlet weak var carOnInsuranceLabelOutlet: UILabel!
    @IBOutlet weak var carNameLabelOutlet: UILabel!
    
    @IBOutlet var insuranceExpirationTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var insuranceStateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    @IBOutlet weak var insuranceExpirationTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var insuranceStateTextFieldOutlet: YBPickerTextField!
    
    @IBOutlet weak var driverNameMatchSwitchOutlet: AIFlatSwitch!
    @IBOutlet weak var carOnInsuranceSwitchOutlet: AIFlatSwitch!
    
    @IBOutlet weak var errorLabelOutlet: UILabel!
    @IBOutlet weak var driverNameMatchLabelOutlet: UILabel!
    
    fileprivate var selectedInsuranceExpDate: Date?
    fileprivate var insuranceCardPictureFileId: String?
    fileprivate var driverLicensePictureFileId: String?
    
    fileprivate let validator: Validator = Validator()

    private let MINIMUM_INSURANCE_EXPIRATION_MONTHS: Int = 1
    
    let testMode: Bool = false
    
    // MARK: - Actions

    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        
        errorLabelOutlet.isHidden = true
        driverNameMatchLabelOutlet.textColor = UIColor.darkGray
        carOnInsuranceLabelOutlet.textColor = UIColor.darkGray
        uploadInsuranceViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        uploadLicenseViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor

        // SWitch validations
        if (!driverNameMatchSwitchOutlet.isSelected) {
            errorLabelOutlet.text = "Driver name has to match documents."
            errorLabelOutlet.isHidden = false
            driverNameMatchLabelOutlet.textColor = UIColor.red
            return;
        }
        
        if (!carOnInsuranceSwitchOutlet.isSelected) {
            errorLabelOutlet.text = "Auto Insurance should include your car."
            errorLabelOutlet.isHidden = false
            carOnInsuranceLabelOutlet.textColor = UIColor.red
            return;
        }
        
        // Pictures validations
        if (self.insuranceCardPictureFileId == nil) {
            errorLabelOutlet.text = "Insurance card picture required."
            errorLabelOutlet.isHidden = false
            uploadInsuranceViewOutlet.layer.borderColor = UIColor.red.cgColor
            return;
        }
        
        if (self.driverLicensePictureFileId == nil) {
            errorLabelOutlet.text = "Driver License picture required."
            errorLabelOutlet.isHidden = false
            uploadLicenseViewOutlet.layer.borderColor = UIColor.red.cgColor
            return;
        }
        
        // Text field validations
        validator.validate(self)
    }
    
    @IBAction func onCarOnInsuranceClick(_ sender: AIFlatSwitch) {
        
    }
    
    @IBAction func onDriverNameMatchClick(_ sender: AIFlatSwitch) {
        
    }
    
    @IBAction func onInsuranceExpirationClick(_ sender: UITapGestureRecognizer) {
        
        DDLogVerbose("onInsuranceExpirationClick")
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        let datePicker = ActionSheetDatePicker(title: InterfaceString.ActionSheet.InsuranceExpirationDate, datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            if let date = value as? Date {
                self.selectedInsuranceExpDate = date
                
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.long
                self.insuranceExpirationTextFieldOutlet.text = formatter.string(from: date)
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: insuranceExpirationTextFieldOutlet);
        
        let minimumInsuranceExpDate = Calendar.current.date(byAdding: .month, value: MINIMUM_INSURANCE_EXPIRATION_MONTHS, to: Date())
        datePicker?.minimumDate = minimumInsuranceExpDate
        
        datePicker?.show()
    }
    
    @IBAction func onInsuranceStateClick(_ sender: UITapGestureRecognizer) {
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.InsuranceState, rows: InterfaceString.Resource.USStatesList, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let state = index as? String {
                self.insuranceStateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: insuranceStateTextFieldOutlet)
    }
    
    // MARK: - Setup
    
    func initProperties() {
        if (self.testMode) {
            
            self.selectedInsuranceExpDate = Date()
            self.insuranceExpirationTextFieldOutlet.text = "February 21, 2019"
            
            self.insuranceStateTextFieldOutlet.text = "California"
            self.insuranceCardPictureFileId = "61de2e4b-cb6a-4f97-89a9-1018de3c5bf5"
            self.driverLicensePictureFileId = "61de2e4b-cb6a-4f97-89a9-1018de3c5bf5"
            driverNameMatchSwitchOutlet.setSelected(true, animated: false)
            carOnInsuranceSwitchOutlet.setSelected(true, animated: false)
        }
    }
    
    func setupUI () {
        self.uploadLicenseViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.License
        self.uploadInsuranceViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.Insurance
        
        let registrationDetails = YBClient.sharedInstance().registrationDetails
        let vehicle = registrationDetails.vehicle
        self.carNameLabelOutlet.text =
                "\(vehicle.make!) \(vehicle.model!) \(vehicle.licensePlate!)"
    }
    
    func setupDelegates() {
        
        self.insuranceExpirationTapGestureRecognizerOutlet.delegate = self
        self.insuranceStateTapGestureRecognizerOutlet.delegate = self
        
        self.insuranceExpirationTextFieldOutlet.delegate = self
        self.insuranceStateTextFieldOutlet.delegate = self
        
        self.uploadLicenseViewOutlet.delegate = self
        self.uploadInsuranceViewOutlet.delegate = self
    }
    
    fileprivate func setupValidator() {
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.appDarkGreen1().cgColor
            }
        }, error:{ (validationError) -> Void in
            
        })
        
        validator.registerField(insuranceExpirationTextFieldOutlet, errorLabel: errorLabelOutlet ,
                                rules: [RequiredRule(message: "Insurance Expiration is required")])
        
        validator.registerField(insuranceStateTextFieldOutlet, errorLabel: errorLabelOutlet ,
                                rules: [RequiredRule(message: "Insurance State is required")])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupDelegates()
        initProperties()
        setupValidator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: bug in ImagePicker: they remove the status bar :(
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
        if (UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // conduct error checks
        
        let insuranceDetails = YBClient.sharedInstance().registrationDetails.insurance
        insuranceDetails.insuranceExpiration = TimeUtil.getISODate(inDate: selectedInsuranceExpDate!)
        insuranceDetails.insuranceState = self.insuranceStateTextFieldOutlet.text!
        insuranceDetails.insuranceCardPicture = self.insuranceCardPictureFileId
        
        let driverLicenseDetails = YBClient.sharedInstance().registrationDetails.driverLicense
        driverLicenseDetails.licensePicture = driverLicensePictureFileId
        
        // Put the Activity on the right bar button item instead of Next Button
//        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        uiBusy.hidesWhenStopped = true
//        uiBusy.startAnimating()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let piViewController = registerStoryboard.instantiateViewController(withIdentifier: "PersonalInformationViewControllerIdentifier") as! PersonalInformationViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(piViewController, animated: true)
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        
        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.insuranceExpirationTextFieldOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
        
        if let validationError = errorDict[self.insuranceExpirationTextFieldOutlet] {
            errorTextField = self.insuranceExpirationTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.insuranceStateTextFieldOutlet] {
            errorTextField = self.insuranceStateTextFieldOutlet
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage
        
        errorTextField.layer.borderColor = UIColor.red.cgColor
    }
}

extension InsuranceViewController: UIGestureRecognizerDelegate {
    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension InsuranceViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DDLogVerbose("textFieldShouldBeginEditing")
        return false
    }
}

extension InsuranceViewController: YBUploadPictureViewDelegate {
    func pictureTaken(_ uploadPictureView: YBUploadPictureView, images: [UIImage], completionBlock: @escaping UploadViewCompletionBlock) {
        if (uploadPictureView == self.uploadInsuranceViewOutlet) {
            
            if let image = images.first {
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                ImageService.sharedInstance().uploadImage(image,
                    cacheKey: .insurancePicture,
                    success: { (url, fileId) in
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        self.insuranceCardPictureFileId = fileId
                        self.uploadInsuranceViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
                        completionBlock(true, nil)
                    },
                    failure: { error in
                        DDLogError("Failure in uploading insurance picture: \(error.description)")
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        completionBlock(false, error)
                })
            }
            
        } else if (uploadPictureView == self.uploadLicenseViewOutlet) {
            
            if let image = images.first {
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                ImageService.sharedInstance().uploadImage(image,
                    cacheKey: .licensePicture,
                    success: { (url, fileId) in
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        self.driverLicensePictureFileId = fileId
                        self.uploadLicenseViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
                        completionBlock(true, nil)
                    },
                    failure: { error in
                        DDLogError("Failure in uploading driverLicense picture: \(error.description)")
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        completionBlock(false, error)
                })
            }
        }
    }
}
