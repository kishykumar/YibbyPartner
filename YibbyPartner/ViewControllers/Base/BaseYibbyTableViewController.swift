//
//  BaseYibbyTableViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 8/21/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import CocoaLumberjack
import MMDrawerController

class BaseYibbyTableViewController: UITableViewController {

    // MARK: - Actions
    
    @objc private func backButtonClicked() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func menuButtonClicked() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    // MARK: - Setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.appBackgroundColor1();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        super.scrollViewDidScroll(scrollView)
        
        for subview in self.view.subviews {
            
            if let menuButton = subview as? YBMenuButton {
                // this is our menu button
                
                menuButton.frame = CGRect(x: menuButton.frame.x, y: scrollView.contentOffset.y + 20.0, width: menuButton.bounds.size.width, height: menuButton.bounds.size.height)
            }
        }
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
