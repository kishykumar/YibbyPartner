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

class LoginViewController: BaseYibbyViewController, IndicatorInfoProvider {
    
    // MARK: - Properties
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButtonOutlet: YibbyButton1!
    
    static let PASSWORD_KEY_NAME = "PASSWORD"
    static let EMAIL_ADDRESS_KEY_NAME = "EMAIL_ADDRESS"
    
    var onStartup = true
    
    // MARK: - Setup functions
    
    func setupDelegates() {
        emailAddress.delegate = self
        password.delegate = self
    }
    
    func setupUI() {
        loginButtonOutlet.color = UIColor.appDarkGreen1()
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
        let ret = KeychainWrapper.standard.set(username, forKey: LoginViewController.EMAIL_ADDRESS_KEY_NAME)
        print("Keychain set value for email : \(ret)")
        KeychainWrapper.standard.set(password, forKey: LoginViewController.PASSWORD_KEY_NAME)
    }
    
    static func removeLoginKeyChainKeys () {
        KeychainWrapper.standard.remove(key: LoginViewController.EMAIL_ADDRESS_KEY_NAME)
        KeychainWrapper.standard.remove(key: LoginViewController.PASSWORD_KEY_NAME)
    }
    
    static func getLoginKeyChainValues () -> (String?, String?) {
        let retrievedEmailAddress = KeychainWrapper.standard.string(forKey: LoginViewController.EMAIL_ADDRESS_KEY_NAME)
        let retrievedPassword = KeychainWrapper.standard.string(forKey: LoginViewController.PASSWORD_KEY_NAME)
        return (retrievedEmailAddress, retrievedPassword)
    }
    
    // MARK: - Helper functions
    
    func submitLoginForm() {
        if (emailAddress.text == "" || password.text == "") {
            AlertUtil.displayAlert("error in form", message: "Please enter email and password")
        } else {
            loginUser(emailAddress.text!, passwordi: password.text!)
        }
    }
    
    // BaasBox login user
    func loginUser(_ usernamei: String, passwordi: String) {
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        
        let client: BAAClient = BAAClient.shared()
        client.authenticateCaber(BAASBOX_DRIVER_STRING, username: usernamei, password: passwordi, completion: {(success, error) -> Void in
            
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
            
            if (success) {
                DDLogVerbose("user logged in successfully \(success)")
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                // if login is successful, save username, password, token in keychain
                LoginViewController.setLoginKeyChainKeys(usernamei, password: passwordi)
                
                if (self.onStartup) {
                    // switch to Main View Controller
                    MainViewController.initMainViewController(self, animated: true)
                } else {
                    appDelegate.sendGCMTokenToServer()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                DDLogVerbose("Error logging in: \(error)")
                
                if ((error as! NSError).domain == BaasBox.errorDomain() && (error as! NSError).code ==
                    WebInterface.BAASBOX_AUTHENTICATION_ERROR) {
                    
                    // check for authentication error and redirect the user to Login page
                    AlertUtil.displayAlert("Username/password incorrect", message: "Please reenter user credentials and try again.")
                }
                else {
                    AlertUtil.displayAlert("Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
                }
            }
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
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailAddress {
            
            password.becomeFirstResponder()
            return false
            
        } else if textField == password {
            
            password.resignFirstResponder()
            return false
            
        }
        
        return true
    }
}
