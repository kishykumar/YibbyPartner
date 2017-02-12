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

class InsuranceViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var uploadLicenseViewOutlet: YBUploadPictureView!
    @IBOutlet weak var uploadInsuranceViewOutlet: YBUploadPictureView!
    @IBOutlet weak var carOnInsuranceLabelOutlet: UILabel!
    
    @IBOutlet var insuranceExpirationTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var insuranceStateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    @IBOutlet weak var insuranceExpirationTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var insuranceStateTextFieldOutlet: YBPickerTextField!
    
    @IBOutlet weak var driverNameMatchSwitchOutlet: AIFlatSwitch!
    @IBOutlet weak var carOnInsuranceSwitchOutlet: AIFlatSwitch!
    
    var selectedInsuranceState: String?
    var selectedInsuranceExpDate: Date?
    
    var insuranceCardPictureFileId: String?
    var driverLicensePictureFileId: String?
    
    private let MINIMUM_INSURANCE_EXPIRATION_MONTHS = 1
    
    let testMode = true
    
    // MARK: - Actions

    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // conduct error checks
        
        let insuranceDetails = YBClient.sharedInstance().registrationDetails.insurance
        insuranceDetails.insuranceExpiration = TimeUtil.getISODate(inDate: self.selectedInsuranceExpDate!)
        insuranceDetails.insuranceState = selectedInsuranceState
        insuranceDetails.insuranceCardPicture = self.insuranceCardPictureFileId
        
        let driverLicenseDetails = YBClient.sharedInstance().registrationDetails.driverLicense
        driverLicenseDetails.licensePicture = driverLicensePictureFileId
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let piViewController = registerStoryboard.instantiateViewController(withIdentifier: "PersonalInformationViewControllerIdentifier") as! PersonalInformationViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(piViewController, animated: true)
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
                self.selectedInsuranceState = state
                self.insuranceStateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: insuranceStateTextFieldOutlet)
    }
    
    // MARK: - Setup
    
    func initProperties() {
        if (self.testMode) {
            self.selectedInsuranceExpDate = Date()
            selectedInsuranceState = "California"
            self.insuranceCardPictureFileId = "61de2e4b-cb6a-4f97-89a9-1018de3c5bf5"
            self.driverLicensePictureFileId = "61de2e4b-cb6a-4f97-89a9-1018de3c5bf5"
        }
    }
    
    func setupUI () {
        self.uploadLicenseViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.License
        self.uploadInsuranceViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.Insurance
    }
    
    func setupDelegates() {
        
        self.insuranceExpirationTapGestureRecognizerOutlet.delegate = self
        self.insuranceStateTapGestureRecognizerOutlet.delegate = self
        
        self.insuranceExpirationTextFieldOutlet.delegate = self
        self.insuranceStateTextFieldOutlet.delegate = self
        
        self.uploadLicenseViewOutlet.delegate = self
        self.uploadInsuranceViewOutlet.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupDelegates()
        initProperties()
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
