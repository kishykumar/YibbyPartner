//
//  FundingInformationViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 12/18/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import CocoaLumberjack
import SwiftValidator

class FundingInformationViewController: BaseYibbyViewController,
                                        UITextFieldDelegate,
                                        ValidationDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var routingNumberTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var accountNumberTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var reenterAccountNumberTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    fileprivate let testMode: Bool = false
    fileprivate let validator: Validator = Validator()

    // MARK: - Actions
    
    @IBAction func onSubmitButtonClick(_ sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    // MARK: - Setup
    
    func initProperties() {
        if (self.testMode) {
            routingNumberTextFieldOutlet.text = "123456789"
            accountNumberTextFieldOutlet.text = "68880456084"
            reenterAccountNumberTextFieldOutlet.text = "68880456084"
        }
    }
    
    func setupUI () {
        
    }
    
    func setupDelegates() {
        self.accountNumberTextFieldOutlet.delegate = self
        self.routingNumberTextFieldOutlet.delegate = self
        self.reenterAccountNumberTextFieldOutlet.delegate = self
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

        validator.registerField(routingNumberTextFieldOutlet, errorLabel: errorLabelOutlet ,
                                rules: [RequiredRule(message: "Routing Number is required")])
        validator.registerField(accountNumberTextFieldOutlet, errorLabel: errorLabelOutlet ,
                                rules: [RequiredRule(message: "Account Number is required")])
        validator.registerField(reenterAccountNumberTextFieldOutlet, errorLabel: errorLabelOutlet ,
                                rules: [RequiredRule(message: "Confirm Account Number"),
                                        ConfirmationRule(confirmField: accountNumberTextFieldOutlet,
                                                         message : "Account Number does not match")])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
        setupDelegates()
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

    // MARK: - Helpers
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
                
        let fundingDetails = YBClient.sharedInstance().registrationDetails.funding
        
        fundingDetails.accountNumber = self.accountNumberTextFieldOutlet.text
        fundingDetails.routingNumber = self.routingNumberTextFieldOutlet.text
        
        // Put the Activity on the right bar button item instead of Next Button
//        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        uiBusy.hidesWhenStopped = true
//        uiBusy.startAnimating()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let consentViewController = registerStoryboard.instantiateViewController(withIdentifier: "ConsentViewControllerIdentifier") as! ConsentViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(consentViewController, animated: true)
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        
        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.routingNumberTextFieldOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
            
        if let validationError = errorDict[self.routingNumberTextFieldOutlet] {
            errorTextField = self.routingNumberTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.routingNumberTextFieldOutlet] {
            errorTextField = self.routingNumberTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.reenterAccountNumberTextFieldOutlet] {
            errorTextField = self.reenterAccountNumberTextFieldOutlet
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage
        
        errorTextField.layer.borderColor = UIColor.red.cgColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.routingNumberTextFieldOutlet ||
            textField == self.accountNumberTextFieldOutlet ||
            textField == self.reenterAccountNumberTextFieldOutlet) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == routingNumberTextFieldOutlet {
            
            accountNumberTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == accountNumberTextFieldOutlet {
            
            reenterAccountNumberTextFieldOutlet.becomeFirstResponder()
            return false
            
        }
        
        return true
    }
}
