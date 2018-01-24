//
//  DriverLicenseViewController.swift
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

class DriverLicenseViewController: BaseYibbyViewController,
                                   ValidationDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var firstNameTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var middleNameTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var lastNameTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var driverLicenseTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var stateTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var birthDateTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var expirationDateTextFieldOutlet: YBPickerTextField!
    
    @IBOutlet weak var commercialLicenseSwitchOutlet: AIFlatSwitch!
    
    @IBOutlet var stateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var birthDateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var expirationDateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    fileprivate var selectedBirthDate: Date?
    fileprivate var selectedExpirationDate: Date?
    fileprivate let validator: Validator = Validator()
    private let MINIMUM_LICENSE_EXPIRATION_MONTHS: Int = 1

    let testMode: Bool = false
    
    // MARK: - Actions
    
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    @IBAction func onCommercialLicenseSwitchValueChange(_ sender: AIFlatSwitch) {
        //isCommercialLicense = commercialLicenseSwitchOutlet.isSelected
    }
    
    @IBAction func onStateTextFieldClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.DriverLicenseState, rows: InterfaceString.Resource.USStatesList, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let state = index as? String {
                self.stateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: stateTextFieldOutlet)
    }
    
    @IBAction func onBirthDateTextFieldClick(_ sender: UITapGestureRecognizer) {

        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        let datePicker = ActionSheetDatePicker(title: InterfaceString.ActionSheet.BirthDate, datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            if let date = value as? Date {
                self.selectedBirthDate = date
                
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.long
                self.birthDateTextFieldOutlet.text = formatter.string(from: date)
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: birthDateTextFieldOutlet);
        
        datePicker?.maximumDate = Date()
        
        datePicker?.show()
    }
    
    @IBAction func onExpirationDateTextFieldClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        let datePicker = ActionSheetDatePicker(title: InterfaceString.ActionSheet.LicenseExpirationDate, datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            if let date = value as? Date {
                self.selectedExpirationDate = date
                
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.long
                self.expirationDateTextFieldOutlet.text = formatter.string(from: date)
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: expirationDateTextFieldOutlet);
        
        let minimumInsuranceExpDate = Calendar.current.date(byAdding: .month, value: MINIMUM_LICENSE_EXPIRATION_MONTHS, to: Date())
        datePicker?.minimumDate = minimumInsuranceExpDate
        
        datePicker?.show()
    }
    
    // MARK: - Setup
    
    func setupDelegates() {
        
        self.stateTapGestureRecognizerOutlet.delegate = self
        self.birthDateTapGestureRecognizerOutlet.delegate = self
        self.expirationDateTapGestureRecognizerOutlet.delegate = self
        
        self.firstNameTextFieldOutlet.delegate = self
        self.middleNameTextFieldOutlet.delegate = self
        self.lastNameTextFieldOutlet.delegate = self
        self.driverLicenseTextFieldOutlet.delegate = self
        self.stateTextFieldOutlet.delegate = self
        self.birthDateTextFieldOutlet.delegate = self
        self.expirationDateTextFieldOutlet.delegate = self
    }
    
    func setupUI() {
        
    }

    func initProperties() {
        
        if (testMode) {
            self.stateTextFieldOutlet.text = "California"
            
            selectedBirthDate = Date()
            self.birthDateTextFieldOutlet.text = "Jan 07, 1989"

            selectedExpirationDate = Date()
            self.expirationDateTextFieldOutlet.text = "Apr 21, 2022"
            
            //isCommercialLicense = true
            self.firstNameTextFieldOutlet.text = "JAMSHID"
            self.lastNameTextFieldOutlet.text = "EBADI"
            self.middleNameTextFieldOutlet.text = ""
            self.driverLicenseTextFieldOutlet.text = "F1234567"
        }
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
        
        validator.registerField(firstNameTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "First Name is required")])
        validator.registerField(lastNameTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Last Name is required")])
        validator.registerField(driverLicenseTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "License # is required")])
        validator.registerField(stateTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "State is required")])
        validator.registerField(expirationDateTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Expiration Date is required")])
        validator.registerField(birthDateTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Birth Date is required")])
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
        
        // conduct error checks
        
        let driverLicenseDetails = YBClient.sharedInstance().registrationDetails.driverLicense
        driverLicenseDetails.dob = TimeUtil.getISODate(inDate: self.selectedBirthDate!)
        driverLicenseDetails.expiration = TimeUtil.getISODate(inDate: self.selectedExpirationDate!)
        driverLicenseDetails.firstName = self.firstNameTextFieldOutlet.text
        driverLicenseDetails.lastName = self.lastNameTextFieldOutlet.text
        driverLicenseDetails.middleName = self.middleNameTextFieldOutlet.text
        driverLicenseDetails.number = self.driverLicenseTextFieldOutlet.text
        driverLicenseDetails.state = self.stateTextFieldOutlet.text
        
        YBClient.sharedInstance().registrationDetails.driving.hasCommercialLicense = commercialLicenseSwitchOutlet.isSelected
        
        // Put the Activity on the right bar button item instead of Next Button
//        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        uiBusy.hidesWhenStopped = true
//        uiBusy.startAnimating()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let insuranceViewController = registerStoryboard.instantiateViewController(withIdentifier: "InsuranceViewControllerIdentifier") as! InsuranceViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(insuranceViewController, animated: true)
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {

        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.firstNameTextFieldOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
        
        if let validationError = errorDict[self.firstNameTextFieldOutlet] {
            errorTextField = self.firstNameTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.middleNameTextFieldOutlet] {
            errorTextField = self.middleNameTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.lastNameTextFieldOutlet] {
            errorTextField = self.lastNameTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.driverLicenseTextFieldOutlet] {
            errorTextField = self.driverLicenseTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.stateTextFieldOutlet] {
            errorTextField = self.stateTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.birthDateTextFieldOutlet] {
            errorTextField = self.birthDateTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.expirationDateTextFieldOutlet] {
            errorTextField = self.expirationDateTextFieldOutlet
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage
        
        errorTextField.layer.borderColor = UIColor.red.cgColor
    }
}

extension DriverLicenseViewController: UIGestureRecognizerDelegate {
    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DriverLicenseViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.firstNameTextFieldOutlet ||
            textField == self.middleNameTextFieldOutlet ||
            textField == self.lastNameTextFieldOutlet ||
            textField == self.driverLicenseTextFieldOutlet) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextFieldOutlet {
            
            middleNameTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == middleNameTextFieldOutlet {
            
            lastNameTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == lastNameTextFieldOutlet {
            
            driverLicenseTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == driverLicenseTextFieldOutlet {
            
            driverLicenseTextFieldOutlet.resignFirstResponder()
            return false
            
        }
        
        return true
    }
}
