//
//  NotificationsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/29/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    // MARK: - Properties
    
    
    // MARK: - Actions
    

    // MARK: - Setup
    
    fileprivate func setupUI() {
        setupBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Helpers

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
