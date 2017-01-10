//
//  JoinViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 8/18/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JoinViewController: BaseYibbyTabViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Actions
    
    
    // MARK: - Setup functions
    
    func setupUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.appDarkGreen1()
    }
    
    override func viewDidLoad() {
        
        // ALERT: this super viewDidLoad should be called after settings are set.
        setupTabBarUI()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupTabBarUI() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
        
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.buttonBarItemTitleColor = .black
        
        // height of the moving bar line
        settings.style.selectedBarHeight = 2.0
        
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        
        // bar left and right contraints
        settings.style.buttonBarLeftContentInset = 0.0
        settings.style.buttonBarRightContentInset = 0.0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = blueInstagramColor
            newCell?.backgroundColor = .red
            newCell?.tintColor = .red
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let loginStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Login, bundle: nil)
        let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as! LoginViewController
        
        let signupStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.SignUp,
                                                          bundle: nil)
        let signupVC = signupStoryboard.instantiateViewController(withIdentifier: "SignupViewControllerIdentifier") as! SignupViewController
        
        let child_1 = loginVC
        let child_2 = signupVC
        
        return [child_1, child_2]
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
