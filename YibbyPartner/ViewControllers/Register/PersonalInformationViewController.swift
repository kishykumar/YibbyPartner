//
//  PersonalInformationViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CocoaLumberjack
import AIFlatSwitch
import SwiftValidator

class PersonalInformationViewController: BaseYibbyViewController,
                                         UIGestureRecognizerDelegate,
                                         UITextFieldDelegate,
                                         ValidationDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var ssnTextFieldOutlet: YBLeftImageTextField!
    @IBOutlet weak var emailTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var streetAddressTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var cityTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var stateTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var zipcodeTextFieldOutlet: YBFloatLabelTextField!
    
    @IBOutlet var stateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    fileprivate var selectedState: String?
    
    fileprivate var profilePictureFileId: String?
    fileprivate let validator: Validator = Validator()

    let testMode: Bool = false
    
    // MARK: - Actions
    
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    @IBAction func onStateClick(_ sender: UITapGestureRecognizer) {
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.AddressState, rows: InterfaceString.Resource.USStatesList, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let state = index as? String {
                self.stateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: stateTextFieldOutlet)
    }
    
    // MARK: - Setup
    
    func initProperties() {
        if (self.testMode) {
            ssnTextFieldOutlet.text = "344230567"
            emailTextFieldOutlet.text = "k.k@gmail.com"
            streetAddressTextFieldOutlet.text = "801 Foster City Blvd"
            cityTextFieldOutlet.text = "Foster City"
            stateTextFieldOutlet.text = "California"
            zipcodeTextFieldOutlet.text = "94404"
        }
    }
    
    func setupUI () {
        
    }
    
    func setupDelegates() {
        
        self.stateTapGestureRecognizerOutlet.delegate = self
        
        self.ssnTextFieldOutlet.delegate = self
        self.emailTextFieldOutlet.delegate = self
        self.streetAddressTextFieldOutlet.delegate = self
        self.cityTextFieldOutlet.delegate = self
        self.stateTextFieldOutlet.delegate = self
        self.zipcodeTextFieldOutlet.delegate = self
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

        validator.registerField(ssnTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "SSN is required"), ExactLengthRule(length: 9, message: "SSN is 9 numbers long.")])
        validator.registerField(emailTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Email is required"), EmailRule()])
        validator.registerField(streetAddressTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Street Address is required")])
        validator.registerField(cityTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "City is required")])
        validator.registerField(stateTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "State is required")])
        validator.registerField(zipcodeTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Zipcode is required"), ZipCodeRule()])
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
        if (UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let licenseDetails = YBClient.sharedInstance().registrationDetails.driverLicense
        let personalDetails = YBClient.sharedInstance().registrationDetails.personal
        personalDetails.ssn = self.ssnTextFieldOutlet.text
        personalDetails.city = self.cityTextFieldOutlet.text
        personalDetails.country = "United States"
        personalDetails.dob = licenseDetails.dob
        personalDetails.emailId = self.emailTextFieldOutlet.text
        personalDetails.profilePicture = self.profilePictureFileId
        personalDetails.state = self.stateTextFieldOutlet.text
        personalDetails.streetAddress = self.streetAddressTextFieldOutlet.text
        personalDetails.postalCode = self.zipcodeTextFieldOutlet.text
        
        let (phoneNumber, password) = LoginViewController.getLoginKeyChainValues()
        personalDetails.phoneNumber = phoneNumber
        
        // Put the Activity on the right bar button item instead of Next Button
//        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        uiBusy.hidesWhenStopped = true
//        uiBusy.startAnimating()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let duViewController = registerStoryboard.instantiateViewController(withIdentifier: "DocumentUploadViewControllerIdentifier") as! DocumentUploadViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(duViewController, animated: true)
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        
        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.ssnTextFieldOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
        
        if let validationError = errorDict[self.ssnTextFieldOutlet] {
            errorTextField = self.ssnTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.emailTextFieldOutlet] {
            errorTextField = self.emailTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.streetAddressTextFieldOutlet] {
            errorTextField = self.streetAddressTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.cityTextFieldOutlet] {
            errorTextField = self.cityTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.stateTextFieldOutlet] {
            errorTextField = self.stateTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.zipcodeTextFieldOutlet] {
            errorTextField = self.zipcodeTextFieldOutlet
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage
        
        errorTextField.layer.borderColor = UIColor.red.cgColor
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.ssnTextFieldOutlet ||
            textField == self.emailTextFieldOutlet ||
            textField == self.streetAddressTextFieldOutlet ||
            textField == self.zipcodeTextFieldOutlet ||
            textField == self.cityTextFieldOutlet) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == ssnTextFieldOutlet {
            
            emailTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == emailTextFieldOutlet {
            
            streetAddressTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == streetAddressTextFieldOutlet {
            
            cityTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == cityTextFieldOutlet {
            
            cityTextFieldOutlet.resignFirstResponder()
            return false
            
        }
        
        return true
    }
}
