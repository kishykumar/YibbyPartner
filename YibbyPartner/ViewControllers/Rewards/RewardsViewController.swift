//
//  RewardsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 12/28/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import MessageUI
import Font_Awesome_Swift

class RewardsViewController: BaseYibbyViewController, MFMailComposeViewControllerDelegate{
    
    // MARK: - Properties

    @IBOutlet weak var rewardView: UIView!
    @IBOutlet weak var referView: UIView!
    @IBOutlet weak var inviteCodeLabelOutlet: UILabel!
    @IBOutlet weak var shareIcon: UILabel!
    
    let EMAIL_BODY:String = "Referrer details: <Your name> <Your phone number> \n - is referring my friend - \n\n Friend details: <Your friend's name> <Your friend's phone number> \n\n Yibby will make $5 payment to you via Venmo once your friend takes a ride with us. \n\n Please provide your venmo id: <Referrer venmo id>"
    let YIBBY_LINK:String = "https://www.google.co.in/"
    
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
        
        inviteCodeLabelOutlet.text = "670JAP"
        shareIcon.setFAText(prefixText: "", icon: FAType.FAShareAltSquare, postfixText: "", size: 30, iconSize: 35)
        
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
    
    func shareInviteCode() {
        if let inviteCode = inviteCodeLabelOutlet.text {
            let text = "Your invite code is \(inviteCode.capitalized)\n\nDownload Yibby here\n"
            if let appLink = NSURL(string:YIBBY_LINK) {
                let objectsToShare = [text,appLink] as [Any]
                let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onInfoClick(_ sender: UIButton) {
        
        let RewardsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Rewards, bundle: nil)
        let ReferRidersInfoVc = RewardsStoryboard.instantiateViewController(withIdentifier: "ReferRiders")
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let mmnvc = appDelegate.centerContainer!.centerViewController as? UINavigationController {
            mmnvc.pushViewController(ReferRidersInfoVc, animated: true)
        }
    }
    
    
    @IBAction func onShareIconClick(_ sender: UITapGestureRecognizer) {
        shareInviteCode()
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
