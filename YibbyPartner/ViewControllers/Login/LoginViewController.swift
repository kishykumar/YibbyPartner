//
//  LoginViewController.swift
//  Example
//
//  Created by Kishy Kumar on 2/13/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import BaasBoxSDK
import CocoaLumberjack
import XLPagerTabStrip
import SwiftKeychainWrapper
import SwiftValidator
import PhoneNumberKit

class LoginViewController: BaseYibbyViewController,
                            IndicatorInfoProvider,
                            ValidationDelegate,
                            UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButtonOutlet: YibbyButton1!
    @IBOutlet weak var errorLabelOutlet: UILabel!
    @IBOutlet weak var phoneNumberTextFieldOutlet: PhoneNumberTextField!
    
    static let PASSWORD_KEY_NAME: String = "PASSWORD"
    static let PHONE_NUMBER_KEY_NAME: String = "PHONE_NUMBER"
    
    var onStartup = true

    let MAX_PHONE_NUMBER_TEXTFIELD_LENGTH = 14 // includes 10 digits, 1 paranthesis "()", 1 hyphen "-", and 1 space " "
    let validator = Validator()
   
    // MARK: - Actions
    
    @IBAction func facebookAction(_ sender: UIButton) {
        AlertUtil.displayAlertOnVC(self, title: "Coming Soon!", message: "Please use our regular login flow.")
        return;
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        AlertUtil.displayAlertOnVC(self, title: "Coming Soon!", message: "Please use our regular login flow.")
        return;
    }
    
    // MARK: - Setup functions
    
    func setupDelegates() {
        phoneNumberTextFieldOutlet.delegate = self
        password.delegate = self
    }
    
    func setupUI() {
        loginButtonOutlet.color = UIColor.appDarkGreen1()
        phoneNumberTextFieldOutlet.defaultRegion = "US"
        
        phoneNumberTextFieldOutlet.text = "6505125555"
        password.text = "Abcdef$123"
    }
    
    func setupValidator() {
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.removeBottomBorder()
            }
        }, error:{ (validationError) -> Void in
            
            //            validationError.errorLabel?.isHidden = false
            //            validationError.errorLabel?.text = validationError.errorMessage
            //
            //            if let textField = validationError.field as? UITextField {
            //                textField.setBottomBorder(UIColor.red)
            //            }
        })
        
        validator.registerField(phoneNumberTextFieldOutlet,
                                errorLabel: self.errorLabelOutlet,
                                rules: [RequiredRule(message: "Phone number is required"),
                                        MinLengthRule(length: MAX_PHONE_NUMBER_TEXTFIELD_LENGTH,
                                                      message: "Must be at least 10 characters long")])
        
        validator.registerField(password,
                                errorLabel: self.errorLabelOutlet,
                                rules: [RequiredRule(message: "Password is required")])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDelegates()
        setupUI()
        setupValidator()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginButtonOutlet.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
                                
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: InterfaceString.Join.Login)
    }
    
    // MARK: - Actions
    @IBAction func loginAction(_ sender: AnyObject) {
        submitLoginForm()
    }
    
    // MARK: - KeyChain functions
    static func setLoginKeyChainKeys (_ username: String, password: String) {
        let ret = KeychainWrapper.standard.set(username, forKey: LoginViewController.PHONE_NUMBER_KEY_NAME)
        print("Keychain set value for phoneNumber : \(ret)")
        KeychainWrapper.standard.set(password, forKey: LoginViewController.PASSWORD_KEY_NAME)
    }
    
    static func removeLoginKeyChainKeys () {
        KeychainWrapper.standard.remove(key: LoginViewController.PHONE_NUMBER_KEY_NAME)
        KeychainWrapper.standard.remove(key: LoginViewController.PASSWORD_KEY_NAME)
    }
    
    static func getLoginKeyChainValues () -> (String?, String?) {
        let retrievedPhoneNumber = KeychainWrapper.standard.string(forKey: LoginViewController.PHONE_NUMBER_KEY_NAME)
        let retrievedPassword = KeychainWrapper.standard.string(forKey: LoginViewController.PASSWORD_KEY_NAME)
        return (retrievedPhoneNumber, retrievedPassword)
    }
    
    // MARK: - Helper functions

    func submitLoginForm() {
        //        emailAddress.text = "1111111111"
        //        password.text = "1"
        
        // Perform text field validations
        validator.validate(self)
    }
    
    // BaasBox login user
    func loginUser(_ usernamei: String, passwordi: String) {
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in

            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            client.authenticateCaber(BAASBOX_DRIVER_STRING, username: usernamei, password: passwordi, completion: {(success, error) -> Void in
                
                ActivityIndicatorUtil.disableActivityIndicator(self.view)
                
                if (success) {
                    DDLogVerbose("user logged in successfully \(success)")
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    // if login is successful, save username, password, token in keychain
                    LoginViewController.setLoginKeyChainKeys(usernamei, password: passwordi)
                    
                    appDelegate.initializeApp()
                }
                else {
                    errorBlock(success, error)
                    
                    // enable the login button interaction
                    self.loginButtonOutlet.isUserInteractionEnabled = true
                }
            })
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        var formattedPhoneNumber = self.phoneNumberTextFieldOutlet.text
        
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        
        if let phoneNumber = formattedPhoneNumber {
            
            // disable the login button interaction if error
            self.loginButtonOutlet.isUserInteractionEnabled = false
            
            loginUser(phoneNumber, passwordi: password.text!)
        }
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        
        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.phoneNumberTextFieldOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
        
        if let validationError = errorDict[phoneNumberTextFieldOutlet] {
            errorTextField = phoneNumberTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.password] {
            errorTextField = self.password
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage

        errorTextField.setBottomBorder(UIColor.red)
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == phoneNumberTextFieldOutlet {
            
            password.becomeFirstResponder()
            return false
            
        } else if textField == password {
            
            password.resignFirstResponder()
            return false
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == phoneNumberTextFieldOutlet) {
            if var str = textField.text {
                str = str + string
                if str.characters.count <= MAX_PHONE_NUMBER_TEXTFIELD_LENGTH {
                    return true
                }
                
                textField.text = str.substring(to: str.index(str.startIndex, offsetBy: MAX_PHONE_NUMBER_TEXTFIELD_LENGTH))
                return false
            }
        }
        
        return true
    }
}
