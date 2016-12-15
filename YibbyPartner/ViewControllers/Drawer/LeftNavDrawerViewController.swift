//
//  LeftNavDrawerViewController.swift
//  Example
//
//  Created by Kishy Kumar on 2/18/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import MMDrawerController
import BaasBoxSDK
import CocoaLumberjack

class LeftNavDrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems: [String] = ["Earnings", "Documents", "Notifications", "Support", "Rewards", "Settings", "Logout"]
    
    enum TableIndex: Int {
        case earnings = 0
        case documents
        case notifications
        case support
        case rewards
        case settings
        case logout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "LeftNavDrawerCellIdentifier", for: indexPath) as! LeftNavDrawerTableViewCell
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        return mycell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedViewController: UIViewController = UIViewController()
        
        switch (indexPath.row) {
        case TableIndex.earnings.rawValue:
            
            let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)
            selectedViewController = earningsStoryboard.instantiateViewController(withIdentifier: "EarningsSummaryViewControllerIdentifier") as! EarningsSummaryViewController
            
            break
            
        case TableIndex.documents.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.notifications.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.support.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.rewards.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.settings.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)
            
            selectedViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
            
        case TableIndex.logout.rawValue:
            
            logoutDriver()
            return;
            
            break
        default: break
        }
        
        // Push the selected view controller to the main navigation controller
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
            
            mmnvc.pushViewController(selectedViewController, animated: true)
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
        } else {
            assert(false)
        }
    }
    
    
    // BaasBox logout driver
    func logoutDriver() {
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        
        let client: BAAClient = BAAClient.shared()
        client.logoutCaber(withCompletion: "driver", completion: {(success, error) -> Void in
            
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
            
            if (success || ((error as! NSError).domain == BaasBox.errorDomain() && (error as! NSError).code ==
                WebInterface.BAASBOX_AUTHENTICATION_ERROR)) {
                
                DDLogInfo("User logged out successfully success: \(success) error: \(error)")

                // pop all the view controllers so that user starts fresh :)
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
                    mmnvc.popToRootViewController(animated: false)
                }
                
                // if logout is successful, remove username, password from keychain
                LoginViewController.removeKeyChainKeys()
                
                let loginStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Login, bundle: nil)

                // Show the LoginViewController View
                if let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as? LoginViewController
                {
                    loginViewController.onStartup = true
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
            else {
                DDLogInfo("Error in logout \(error)")
                // We continue the user session if Logout hits an error
                if ((error as! NSError).domain == BaasBox.errorDomain()) {
                    AlertUtil.displayAlert("Error Logging out. ", message: "This is...weird. \((error as! NSError).description)")
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
