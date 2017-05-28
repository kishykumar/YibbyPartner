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
//import DigitsKit

class SignupViewController: BaseYibbyViewController, IndicatorInfoProvider {
    
    // MARK: - Properties
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var emailAddressOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var signupButtonOutlet: YibbyButton1!
    @IBOutlet weak var tandcButtonOutlet: UIButton!
    
    // flag to test creating the same user without calling the webserver.
    let testMode = false
    
    // MARK: - Actions
    
    @IBAction func submitFormButton(_ sender: UIButton) {
        submitForm()
    }
    
    @IBAction func tncButtonAction(_ sender: AnyObject) {
        let url = URL(string: "https://google.com")!
        UIApplication.shared.openURL(url)
    }
    
    // MARK: - Setup functions
    
    func setupUI() {
        signupButtonOutlet.color = UIColor.appDarkGreen1()
        
        let attrTitle = NSAttributedString(string: InterfaceString.Button.TANDC,
                                           attributes: [NSForegroundColorAttributeName : UIColor.appDarkGreen1(),
                                                        NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12.0),
                                                        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        tandcButtonOutlet.setAttributedTitle(attrTitle, for: UIControlState())
    }
    
    func setupDelegates() {
        nameOutlet.delegate = self
        emailAddressOutlet.delegate = self
        phoneNumberOutlet.delegate = self
        passwordOutlet.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDelegates()
        setupUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func submitForm() {
        if nameOutlet.text == ""{
            
            AlertUtil.displayAlert("error in form", message: "Enter name")
        }
            
        else if emailAddressOutlet.text! == "" {
            
            AlertUtil.displayAlert("error in form", message: "Enter email address")
        }
//        else if !isValidEmail(testStr: emailAddressOutlet.text!){
//            
//            AlertUtil.displayAlert("error in form", message: "Enter valid email address")
//        }
        else if passwordOutlet.text == "" {
            
            AlertUtil.displayAlert("error in form", message: "Enter password")
        }
            /*  else if  !isValidPassword(testStr: passwordOutlet.text!){
             
             
             AlertUtil.displayAlert("error in form", message: "Password must be more than six characters with minimum one numeric and special character")
             
             }*/
        else if phoneNumberOutlet.text! == ""{
            
            AlertUtil.displayAlert("error in form", message: "Enter phone no")
        }
            /* else if  !isValidPhoneNo(testStr: phoneNumberOutlet.text!){
             
             AlertUtil.displayAlert("error in form", message: "Enter valid phone no")
             
             }*/
        else{
            
            
//            let digits = Digits.sharedInstance()
//            let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
//            // configuration?.phoneNumber = self.txtPhone.text!
//            
//            let digitsAppearance = DGTAppearance()
//            
//            digitsAppearance.accentColor = UIColor.red
//            digitsAppearance.applyUIAppearanceColors()
//            configuration?.appearance = digitsAppearance
//            digits.authenticate(with: nil, configuration: configuration!) { session, error in
//                
//                if((error?.localizedDescription) != nil)
//                {
//                    digits.logOut()
//                    
//                    self.phoneNumberOutlet.text = ""
//                }
//                else
//                {
//                    digits.logOut()
//                    
//                    self.phoneNumberOutlet.text =  (session?.phoneNumber)!
//                    
//                    self.createUser(self.nameOutlet.text!, emaili: self.emailAddressOutlet.text!, phoneNumberi: self.phoneNumberOutlet.text!, passwordi: self.passwordOutlet.text!)
//                    
//                }
//                // Country selector will be set to Spain and phone number field will be set to 5555555555
//            }
            
            self.createUser(self.nameOutlet.text!, emaili: self.emailAddressOutlet.text!, phoneNumberi: self.phoneNumberOutlet.text!, passwordi: self.passwordOutlet.text!)
        }
    }
    
    // BaasBox create user
    func createUser(_ usernamei: String, emaili: String, phoneNumberi: String, passwordi: String) {
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        
        let client: BAAClient = BAAClient.shared()
        
        client.createCaber(BAASBOX_DRIVER_STRING, name: usernamei, email: emaili, phoneNumber: phoneNumberi, password: passwordi, completion:{(success, error) -> Void in
            if (success || self.testMode) {
                DDLogVerbose("Success signing up: \(success)")
                
                // if login is successful, save username, password, token in keychain
                LoginViewController.setLoginKeyChainKeys(usernamei, password: passwordi)
                
                let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
                let initialRegisterController = registerStoryboard.instantiateViewController(withIdentifier: "VehicleViewControllerIdentifier") as! VehicleViewController
                
                self.navigationController!.pushViewController(initialRegisterController, animated: true)
            }
            else {
                DDLogVerbose("Signup failed: \(error)")
                AlertUtil.displayAlert("Signup failed.", message: "Please try again.")
            }
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
        })
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: InterfaceString.Join.Signup)
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    
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
    
}
