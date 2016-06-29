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

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    static let PASSWORD_KEY_NAME = "PASSWORD"
    static let EMAIL_ADDRESS_KEY_NAME = "EMAIL_ADDRESS"
    
    var onStartup = true

    // MARK: functions
    @IBAction func loginAction(sender: AnyObject) {
        
        
        if (emailAddress.text == "" || password.text == "") {
            Util.displayAlert("error in form", message: "Please enter email and password")
        } else {
            loginDriver(emailAddress.text!, passwordi: password.text!)
        }
    }
    
    // MARK: KeyChain functions
    static func setKeyChainKeys (username: String, password: String) {
        KeychainWrapper.setString(username, forKey: LoginViewController.EMAIL_ADDRESS_KEY_NAME)
        KeychainWrapper.setString(password, forKey: LoginViewController.PASSWORD_KEY_NAME)
    }
    
    static func removeKeyChainKeys () {
        KeychainWrapper.removeObjectForKey(LoginViewController.EMAIL_ADDRESS_KEY_NAME)
        KeychainWrapper.removeObjectForKey(LoginViewController.PASSWORD_KEY_NAME)
    }
    
    static func getKeyChainKeys () -> (String?, String?) {
        let retrievedEmailAddress = KeychainWrapper.stringForKey(LoginViewController.EMAIL_ADDRESS_KEY_NAME)
        let retrievedPassword = KeychainWrapper.stringForKey(LoginViewController.PASSWORD_KEY_NAME)
        return (retrievedEmailAddress, retrievedPassword)
    }
    
    // BaasBox login user
    func loginDriver(usernamei: String, passwordi: String) {
        Util.enableActivityIndicator(self.view)

        let client: BAAClient = BAAClient.sharedClient()
        client.authenticateCaber(BAASBOX_DRIVER_STRING, username: usernamei, password: passwordi, completion: {(success, error) -> Void in
            Util.disableActivityIndicator(self.view)
            
            if (success) {
                DDLogVerbose("user logged in successfully \(success)")
                
                // if login is successful, save username, password, token in keychain
                LoginViewController.setKeyChainKeys(usernamei, password: passwordi)
                
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.initializeMainViewController()
                appDelegate.sendGCMTokenToServer()
                
                if (self.onStartup) {
                    // switch to Main View Controller
                    appDelegate.initializeMainViewController()
                    self.presentViewController(appDelegate.centerContainer!, animated: true, completion: nil)
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            else {
                DDLogVerbose("Error logging in: \(error)")
                if (error.domain == BaasBox.errorDomain() && error.code ==
                    WebInterface.BAASBOX_AUTHENTICATION_ERROR) {
                    
                    // check for authentication error and redirect the user to Login page
                    Util.displayAlert("Username/password incorrect", message: "Please reenter user credentials and try again.")
                }
                else {
                    Util.displayAlert("Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
                }
            }
        })
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
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

}
