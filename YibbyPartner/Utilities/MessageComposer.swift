//
//  MessageComposer.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 9/21/17.
//  Copyright © 2017 YibbyPartner. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(phoneNumber: String) -> MFMessageComposeViewController {
        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = [phoneNumber]
        messageComposeVC.body = "Hello. Your Yibby driver here! "
        return messageComposeVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
