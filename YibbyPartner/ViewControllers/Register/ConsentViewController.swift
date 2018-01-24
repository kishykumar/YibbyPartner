//
//  ConsentViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import AIFlatSwitch
//import SwiftValidator
import BaasBoxSDK

class ConsentViewController: BaseYibbyViewController {

    // MARK: - Properties
    //fileprivate let validator = Validator()

    @IBOutlet weak var consentSwitchOutlet: AIFlatSwitch!
    @IBOutlet weak var consentLabelOutlet: UILabel!
    
    // MARK: - Actions
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        
        consentLabelOutlet.textColor = UIColor.darkGray
        
        if (!consentSwitchOutlet.isSelected) {
            consentLabelOutlet.textColor = UIColor.red
            return;
        }
        
        validationSuccessful()
    }
    
    @IBAction func onConsentClick(_ sender: AIFlatSwitch) {

    }
    
    // MARK: - Setup
    
    func setupUI () {
        
    }
    
    fileprivate func setupValidator() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupValidator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        
        // send the driver registration details to webserver
        let registrationDetails = YBClient.sharedInstance().registrationDetails
        DDLogVerbose("Final RegisterJSON is : \(String(describing: registrationDetails.toJSONString(prettyPrint: true)))")
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in

            ActivityIndicatorUtil.enableActivityIndicator(self.view)
            
            let client: BAAClient = BAAClient.shared()
            client.completeDriverRegistration(registrationDetails.toJSON(), completion: {(success, error) -> Void in

                ActivityIndicatorUtil.disableActivityIndicator(self.view)
                
                if (success) {
                    DDLogVerbose("registration details sent successfully success: \(success) error: \(String(describing: error))")
                    let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
                    
                    let paViewController = registerStoryboard.instantiateViewController(withIdentifier: "PendingApprovalViewControllerIdentifier") as! PendingApprovalViewController
                    
                    // get the navigation VC and push the new VC
                    self.navigationController!.pushViewController(paViewController, animated: true)
                }
                else {
                    DDLogVerbose("registration details sent FAILED \(String(describing: error)))")
                    errorBlock(success, error)
                }
            })
        })
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
