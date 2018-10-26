//
//  ReferRidersViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 10/26/18.
//  Copyright © 2018 MyComp. All rights reserved.
//

import UIKit

class ReferRidersViewController: UIViewController {

    
    @IBOutlet weak var inviteDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        setupBackButton()
        inviteDescriptionTextView.layer.borderColor = UIColor.borderColor().cgColor
        inviteDescriptionTextView.layer.borderWidth = 1.0
        inviteDescriptionTextView.layer.cornerRadius = 7
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
