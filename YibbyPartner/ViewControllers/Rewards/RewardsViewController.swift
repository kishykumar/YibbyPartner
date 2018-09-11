//
//  RewardsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 12/28/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import MessageUI

class RewardsViewController: BaseYibbyViewController, MFMailComposeViewControllerDelegate{
    
    // MARK: - Properties

    @IBOutlet weak var rewardView: UIView!
    @IBOutlet weak var referView: UIView!
    
    
    let EMAIL_BODY:String = "Referrer details: <Your name> <Your phone number> \n - is referring my friend - \n\n Friend details: <Your friend's name> <Your friend's phone number> \n\n Yibby will make $5 payment to you via Venmo once your friend takes a ride with us. \n\n Please provide your venmo id: <Referrer venmo id>"
    
    // MARK: - Actions
    
    
    // MARK: - Setup
    
    fileprivate func setupUI() {
        setupBackButton()
        
        rewardView.layer.borderColor = UIColor.borderColor().cgColor
        rewardView.layer.borderWidth = 1.0
        rewardView.layer.cornerRadius = 7
        
        referView.layer.borderColor = UIColor.borderColor().cgColor
        referView.layer.borderWidth = 1.0
        referView.layer.cornerRadius = 7
        
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
    
    @IBAction func contactYibbyButtonAction(_ sender: UIButton) {
        sendEmail()
    }
    
    
    func sendEmail(){
        if !MFMailComposeViewController.canSendMail(){
            ToastUtil.displayToastOnVC(self, title: "Mail account not configured", body: "Mail Services are not available. Please configure a mail account to send Referrals", theme: .warning, presentationStyle: .center, duration: .seconds(seconds: 5), windowLevel: UIWindowLevelNormal)
            return
        }
        let composeVc = MFMailComposeViewController()
        composeVc.mailComposeDelegate = self
        composeVc.setToRecipients(["support@yibby.zohodesk.com"])
        composeVc.setSubject("Yibby Referral")
        composeVc.setMessageBody(EMAIL_BODY, isHTML: false)
        self.present(composeVc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
