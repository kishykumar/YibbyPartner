//
//  RewardsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 12/28/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit

class RewardsViewController: BaseYibbyViewController{
    
    // MARK: - Properties
    
    @IBOutlet weak var rewardViewOutlet: UIView!
    
    // MARK: - Actions
    
    
    // MARK: - Setup
    
    fileprivate func setupUI() {
        setupBackButton()
        rewardViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        rewardViewOutlet.layer.borderWidth = 1
        rewardViewOutlet.layer.cornerRadius = 7
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
