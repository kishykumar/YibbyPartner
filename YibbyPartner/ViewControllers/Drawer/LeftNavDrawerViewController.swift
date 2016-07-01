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
    
    var menuItems: [String] = ["History", "Settings", "Promotions", "Help", "About", "Logout"]
    
    enum TableIndex: Int {
        case History = 0
        case Settings
        case Promotions
        case Help
        case About
        case Logout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCellWithIdentifier("LeftNavDrawerCellIdentifier", forIndexPath: indexPath) as! LeftNavDrawerTableViewCell
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        return mycell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedViewController: UIViewController = UIViewController()
        
        switch (indexPath.row) {
        case TableIndex.History.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)
            selectedViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.Settings.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.Promotions.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.Help.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.About.rawValue:
            
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Settings, bundle: nil)

            selectedViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsViewControllerIdentifier") as! SettingsViewController
            
            break
        case TableIndex.Logout.rawValue:
            
            logoutDriver()
            return;
            
            break
        default: break
        }
        
        // Push the selected view controller to the main navigation controller
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
            
            mmnvc.pushViewController(selectedViewController, animated: true)
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        } else {
            assert(false)
        }
    }
    
    
    // BaasBox logout driver
    func logoutDriver() {
        Util.enableActivityIndicator(self.view)
        
        let client: BAAClient = BAAClient.sharedClient()
        client.logoutCaberWithCompletion("driver", completion: {(success, error) -> Void in
            
            Util.disableActivityIndicator(self.view)
            
            if (success || (error.domain == BaasBox.errorDomain() && error.code ==
                WebInterface.BAASBOX_AUTHENTICATION_ERROR)) {
                
                DDLogInfo("User logged out successfully success: \(success) error: \(error)")

                // pop all the view controllers so that user starts fresh :)
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
                    mmnvc.popToRootViewControllerAnimated(false)
                }
                
                // if logout is successful, remove username, password from keychain
                LoginViewController.removeKeyChainKeys()
                
                let loginStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Login, bundle: nil)

                // Show the LoginViewController View
                if let loginViewController = loginStoryboard.instantiateViewControllerWithIdentifier("LoginViewControllerIdentifier") as? LoginViewController
                {
                    loginViewController.onStartup = true
                    self.presentViewController(loginViewController, animated: true, completion: nil)
                }
            }
            else {
                DDLogInfo("Error in logout \(error)")
                // We continue the user session if Logout hits an error
                if (error.domain == BaasBox.errorDomain()) {
                    Util.displayAlert("Error Logging out. ", message: "This is...weird. \(error.description)")
                }
                else {
                    Util.displayAlert("Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
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
