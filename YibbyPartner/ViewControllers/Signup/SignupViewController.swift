//
//  SignupViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 2/28/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import BaasBoxSDK
import CocoaLumberjack
import XLPagerTabStrip
import SwiftValidator
import PhoneNumberKit
import AccountKit

class SignupViewController: BaseYibbyViewController,
                            IndicatorInfoProvider,
                            ValidationDelegate,
                            UITextFieldDelegate,
                            AKFViewControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var emailAddressOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: PhoneNumberTextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var signupButtonOutlet: YibbyButton1!
    @IBOutlet weak var tandcButtonOutlet: UIButton!
    
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    // flag to test creating the same user without calling the webserver.
    fileprivate let testMode: Bool = false
    
    fileprivate let MAX_PHONE_NUMBER_TEXTFIELD_LENGTH: Int = 14 // includes 10 digits, 1 paranthesis "()", 1 hyphen "-", and 1 space " "

    fileprivate let validator: Validator = Validator()

    fileprivate var accountKit: AKFAccountKit!
    fileprivate var formattedPhoneNumber: String?
    
    // MARK: - Actions
    
    @IBAction func submitFormButton(_ sender: UIButton) {
        submitForm()
    }
    
    @IBAction func tncButtonAction(_ sender: AnyObject) {
        let url = URL(string: "http://yibbyapp.com")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - Setup functions
    
    func setupUI() {
        signupButtonOutlet.color = UIColor.appDarkGreen1()
        
        let attrTitle = NSAttributedString(string: InterfaceString.Button.TANDC,
                                           attributes: [NSAttributedStringKey.foregroundColor : UIColor.appDarkGreen1(),
                                                        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12.0),
                                                        NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        tandcButtonOutlet.setAttributedTitle(attrTitle, for: UIControlState())
        
        phoneNumberOutlet.defaultRegion = "US"
    }
    
    func setupDelegates() {
        nameOutlet.delegate = self
        emailAddressOutlet.delegate = self
        phoneNumberOutlet.delegate = self
        passwordOutlet.delegate = self
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
        
        validator.registerField(nameOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Full Name is required"), FullNameRule()])
        
        validator.registerField(emailAddressOutlet,
                                errorLabel: self.errorLabelOutlet,
                                rules: [RequiredRule(message: "Email Address is required"), EmailRule()])
        
        validator.registerField(phoneNumberOutlet,
                                errorLabel: self.errorLabelOutlet,
                                rules: [RequiredRule(message: "Phone number is required"),
                                        MinLengthRule(length: MAX_PHONE_NUMBER_TEXTFIELD_LENGTH,
                                                      message: "Must be at least 10 characters long")])
        
        validator.registerField(passwordOutlet,
                                errorLabel: self.errorLabelOutlet,
                                rules: [RequiredRule(message: "Password is required"), YBPasswordRule()])
    }
    
    fileprivate func initProperties() {
        self.accountKit = AKFAccountKit(responseType: .accessToken)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initProperties()
        setupDelegates()
        setupUI()
        setupValidator()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.signupButtonOutlet.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        
        var formattedPhoneNumber = self.phoneNumberOutlet.text
        
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        formattedPhoneNumber =
            formattedPhoneNumber?.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        
        //formattedPhoneNumber = "+1\(formattedPhoneNumber!)"
        DDLogVerbose("KKDBG_formattedPhno: \(formattedPhoneNumber!)")
        
        self.formattedPhoneNumber = formattedPhoneNumber
        verifyPhoneNumber(formattedPhoneNumber!)
        
//        // Firebase phone number verification
//        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber!) { (verificationID, error) in
//
//            if let error = error {
//                DDLogVerbose("KKDBG error: \(error.localizedDescription)")
//                return
//            }
//
//            // Successful. -> it's sucessfull here
//            print(verificationID)
//            UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
//            UserDefaults.standard.synchronize()
//
//            // Sign in using the verificationID and the code sent to the user
//            // ...
//            DDLogVerbose("KKDBG success signing up phno: \(String(describing: formattedPhoneNumber))")
//
//        }
        
        
        //let digits = Digits.sharedInstance()
        //let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        
        //let digitsAppearance = DGTAppearance()
        
        //digitsAppearance.accentColor = UIColor.appDarkGreen1()
        //digitsAppearance.applyUIAppearanceColors()
        //configuration?.appearance = digitsAppearance
        //configuration?.phoneNumber = formattedPhoneNumber
        
//        digits.authenticate(with: nil, configuration: configuration!) { session, error in
//            
//            if((error?.localizedDescription) != nil) {
//                digits.logOut()
//            }
//            else {
//                digits.logOut()
//                
//                // self.phoneNumberOutlet.text =  (session?.phoneNumber)!
//                
//                self.createUser(self.nameOutlet.text!, emaili: self.emailAddressOutlet.text!,
//                                phoneNumberi: formattedPhoneNumber!, passwordi: self.passwordOutlet.text!)
//            }
//            // Country selector will be set to Spain and phone number field will be set to 5555555555
//        }
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {

        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.nameOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
        
        if let validationError = errorDict[nameOutlet] {
            errorTextField = nameOutlet
            verror = validationError
        } else if let validationError = errorDict[self.phoneNumberOutlet] {
            errorTextField = self.phoneNumberOutlet
            verror = validationError
        } else if let validationError = errorDict[self.emailAddressOutlet] {
            errorTextField = self.emailAddressOutlet
            verror = validationError
        } else if let validationError = errorDict[self.passwordOutlet] {
            errorTextField = self.passwordOutlet
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage
        
        errorTextField.setBottomBorder(UIColor.red)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Helper Functions
    
    fileprivate func verifyPhoneNumber(_ formattedPhoneNumber: String) {
        
        let prefillPhoneNumber = AKFPhoneNumber(countryCode: "+1", phoneNumber: formattedPhoneNumber)
        let inputState: String = UUID().uuidString
        
        if let viewController = self.accountKit.viewControllerForPhoneLogin(with: prefillPhoneNumber, state: inputState) as? AKFViewController {
            prepareLoginViewController(viewController)
            
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }

    fileprivate func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
        loginViewController.enableGetACall = true
    }
    
    fileprivate func submitForm() {
        validator.validate(self)
    }
    
    // BaasBox create user
    fileprivate func createUser(_ namei: String, emaili: String, phoneNumberi: String, passwordi: String) {
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            client.createCaber(BAASBOX_DRIVER_STRING, name: namei, email: emaili, phoneNumber: phoneNumberi, password: passwordi, completion:{(success, error) -> Void in
                if (success || self.testMode) {
                    DDLogVerbose("Success signing up: \(success)")
                    
                    // if login is successful, save username, password, token in keychain
                    LoginViewController.setLoginKeyChainKeys(phoneNumberi, password: passwordi)
                    
                    let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
                    let initialRegisterController = registerStoryboard.instantiateViewController(withIdentifier: "VehicleViewControllerIdentifier") as! VehicleViewController
                    
                    self.navigationController!.pushViewController(initialRegisterController, animated: true)
                }
                else {
                    DDLogVerbose("Signup failed: \(String(describing: error))")
                    errorBlock(success, error)
                }
                
                self.signupButtonOutlet.isUserInteractionEnabled = true
                ActivityIndicatorUtil.disableActivityIndicator(self.view)
            })
        })
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: InterfaceString.Join.Signup)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameOutlet {
            
            phoneNumberOutlet.becomeFirstResponder()
            return false
            
        } else if textField == phoneNumberOutlet {
            
            emailAddressOutlet.becomeFirstResponder()
            return false
            
        } else if textField == emailAddressOutlet {
            
            passwordOutlet.becomeFirstResponder()
            return false
            
        } else if textField == passwordOutlet {
            
            passwordOutlet.resignFirstResponder()
            return false
            
        }
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == phoneNumberOutlet) {
            if var str = textField.text {
                str = str + string
                if str.count <= MAX_PHONE_NUMBER_TEXTFIELD_LENGTH {
                    return true
                }

                let index = str.index(str.startIndex, offsetBy: MAX_PHONE_NUMBER_TEXTFIELD_LENGTH)
                textField.text = String(str[..<index])
                return false
            }
        }
        
        return true
    }
    
    // MARK: - AKFViewControllerDelegate extension
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        // login success
        DDLogVerbose("Login Success")
        
        accountKit.logOut()
        
        // disable login button
        self.signupButtonOutlet.isUserInteractionEnabled = false

        self.createUser(self.nameOutlet.text!, emaili: self.emailAddressOutlet.text!,
                        phoneNumberi: self.formattedPhoneNumber!, passwordi: self.passwordOutlet.text!)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // login failed
        DDLogVerbose("\(viewController) did fail with error: \(error)")
        accountKit.logOut()
    }
}
