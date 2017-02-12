//
//  DocumentUploadViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import BaasBoxSDK

typealias DriverRegstrationCompletionBlock = () -> Void

class DocumentUploadViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var profilePictureViewOutlet: YBUploadPictureView!
    @IBOutlet weak var vehicleInspFormOutlet: YBUploadPictureView!
    
    var profilePictureFileId: String?
    var vehicleInspFormFileId: String?
    
    let testMode = false
    
    // MARK: - Actions
    
    @IBAction func onSubmitBarButtonClick(_ sender: UIBarButtonItem) {
        
        // conduct error checks
        
        let personalDetails = YBClient.sharedInstance().registrationDetails.personal
        personalDetails.profilePicture = profilePictureFileId
        
        let vehicleDetails = YBClient.sharedInstance().registrationDetails.vehicle
        vehicleDetails.inspectionFormPicture = vehicleInspFormFileId
        
        submitRegistrationDetails(completionBlock: { () -> Void in
            
            let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
            
            let paViewController = registerStoryboard.instantiateViewController(withIdentifier: "PendingApprovalViewControllerIdentifier") as! PendingApprovalViewController
            
            // get the navigation VC and push the new VC
            self.navigationController!.pushViewController(paViewController, animated: true)
        })
    }
    
    // MARK: - Setup
    
    func initProperties() {
        if (self.testMode) {
            profilePictureFileId = "61de2e4b-cb6a-4f97-89a9-1018de3c5bf5"
            vehicleInspFormFileId = "61de2e4b-cb6a-4f97-89a9-1018de3c5bf5"
        }
    }
    
    func setupUI () {
        self.profilePictureViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.ProfilePicture
        self.vehicleInspFormOutlet.uploadLabelOutlet.text = InterfaceString.Upload.VehicleInspectionForm
    }
    
    func setupDelegates() {
        self.vehicleInspFormOutlet.delegate = self
        self.profilePictureViewOutlet.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupDelegates()
        initProperties()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // TODO: bug in ImagePicker: they remove the status bar :(
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
        if (UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper functions
    
    private func submitRegistrationDetails(completionBlock: @escaping DriverRegstrationCompletionBlock) {
        
        // send the driver registration details to webserver
        let registrationDetails = YBClient.sharedInstance().registrationDetails
        DDLogVerbose("Final RegisterJSON is : \(registrationDetails.toJSONString(prettyPrint: true))")
        
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        
        let client: BAAClient = BAAClient.shared()
        client.completeDriverRegistration(registrationDetails.toJSON(), completion: {(success, error) -> Void in
            
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
            
            if (success || self.testMode) {
                DDLogVerbose("registration details sent successfully success: \(success) error: \(error)")
                completionBlock()
            }
            else {
                DDLogVerbose("registration details sent FAILED \(error))")
                
                if ((error as! NSError).domain == BaasBox.errorDomain() && (error as! NSError).code ==
                    WebInterface.BAASBOX_AUTHENTICATION_ERROR) {
                    
                    // check for authentication error and redirect the user to Login page
                    AlertUtil.displayAlert("Username/password incorrect", message: "Please reenter user credentials and try again.")
                }
                else {
                    AlertUtil.displayAlert("Connectivity or Server Issues.", message: "Please check your internet connection or wait for some time.")
                }
            }
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

extension DocumentUploadViewController: YBUploadPictureViewDelegate {
    
    func pictureTaken(_ uploadPictureView: YBUploadPictureView, images: [UIImage], completionBlock: @escaping UploadViewCompletionBlock) {
        if (uploadPictureView == self.profilePictureViewOutlet) {
            if let image = images.first {
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                ImageService.sharedInstance().uploadImage(image,
                    cacheKey: .profilePicture,
                    success: { (url, fileId) in
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        self.profilePictureFileId = fileId
                        completionBlock(true, nil)
                    },
                    failure: { error in
                        DDLogError("Failure in uploading profile picture: \(error.description)")
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        completionBlock(false, error)
                    })
            }
            
        } else if (uploadPictureView == self.vehicleInspFormOutlet) {
            if let image = images.first {
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                ImageService.sharedInstance().uploadImage(image,
                    cacheKey: .vehicleInspectionPicture,
                    success: { (url, fileId) in
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        self.vehicleInspFormFileId = fileId
                        completionBlock(true, nil)
                    },
                    failure: { error in
                        DDLogError("Failure in uploading vehicleInspForm picture: \(error.description)")
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        completionBlock(false, error)
                })
            }
        }
    }
}
