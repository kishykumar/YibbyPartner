//
//  LegalVC.swift
//  sr
//
//  Created by Rahul Mehndiratta on 10/03/17.
//  Copyright © 2017 Rahul Mehndiratta. All rights reserved.
//

import UIKit

class LegalVC: BaseYibbyViewController {

    @IBOutlet var privacyPolicyBtn: UIButton!
    @IBOutlet var termsOfServiceBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        setupBackButton()
        
        privacyPolicyBtn.layer.borderColor = UIColor.borderColor().cgColor
        privacyPolicyBtn.layer.borderWidth = 1.0
        privacyPolicyBtn.layer.cornerRadius = 7
        
        termsOfServiceBtn.layer.borderColor = UIColor.borderColor().cgColor
        termsOfServiceBtn.layer.borderWidth = 1.0
        termsOfServiceBtn.layer.cornerRadius = 7
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func privacyPolicyBtnAction(_ sender: Any) {
    }
    
    @IBAction func termsOfServiceBtnAction(_ sender: Any) {
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
