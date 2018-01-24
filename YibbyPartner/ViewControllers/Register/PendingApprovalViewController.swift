//
//  PendingApprovalViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/18/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit

class PendingApprovalViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    
    // MARK: Actions
    
    @IBAction func onLearnMoreButtonClick(_ sender: UIButton) {
        let url = URL(string: "http://yibbyapp.com")!
        UIApplication.shared.openURL(url)
    }
    
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        // remove navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
