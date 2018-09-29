//
//  LostOrStolenItemVC.swift
//  Yibby
//
//  Created by Rahul Mehndiratta on 25/02/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit

class LostItemViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var contactRiderOutlet: UIView!
    @IBOutlet weak var contactYibbyOutlet: UIView!
    @IBOutlet weak var contactInfoViewOutlet: UIView!
    @IBOutlet weak var callRiderButtonOutlet: YibbyButton1!
    @IBOutlet weak var emailYibbyButtonOutlet: YibbyButton1!
    var myTrip: Ride!

    // MARK: - Actions
    
    @IBAction func onCallRiderClick(_ sender: UITapGestureRecognizer) {
        if let myRider = myTrip.rider {
            myRider.call()
        }
    }

    @IBAction func onEmailClick(_ sender: UITapGestureRecognizer) {
        let email = "support@yibby.zohodesk.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupUI()
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        setupBackButton()
        
        callRiderButtonOutlet.buttonCornerRadius = 5.0
        callRiderButtonOutlet.color = UIColor.appDarkGreen1()
        
        emailYibbyButtonOutlet.buttonCornerRadius = 5.0
        emailYibbyButtonOutlet.color = UIColor.appDarkGreen1()
        
        contactYibbyOutlet.layer.cornerRadius = 7
        contactYibbyOutlet.layer.borderWidth = 1
        contactYibbyOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        contactRiderOutlet.layer.cornerRadius = 7
        contactRiderOutlet.layer.borderWidth = 1
        contactRiderOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        
        contactInfoViewOutlet.layer.cornerRadius = 7
        contactInfoViewOutlet.layer.borderWidth = 1
        contactInfoViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
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
