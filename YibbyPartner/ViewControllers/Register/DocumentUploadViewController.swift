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
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    fileprivate var profilePictureFileId: String?
    fileprivate var vehicleInspFormFileId: String?

    let testMode: Bool = false
    
    // MARK: - Actions
    
    @IBAction func onSubmitBarButtonClick(_ sender: UIBarButtonItem) {
        
        errorLabelOutlet.isHidden = true
        profilePictureViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
        vehicleInspFormOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor

        // Pictures validations
        if (self.profilePictureFileId == nil) {
            errorLabelOutlet.text = "Insurance card picture required."
            errorLabelOutlet.isHidden = false
            profilePictureViewOutlet.layer.borderColor = UIColor.red.cgColor
            return;
        }
        
        if (self.vehicleInspFormFileId == nil) {
            errorLabelOutlet.text = "Driver License picture required."
            errorLabelOutlet.isHidden = false
            vehicleInspFormOutlet.layer.borderColor = UIColor.red.cgColor
            return;
        }
        
        validationSuccessful()
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
    
    func validationSuccessful() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Put the Activity on the right bar button item instead of Next Button
//        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        uiBusy.hidesWhenStopped = true
//        uiBusy.startAnimating()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let vehicleDetails = YBClient.sharedInstance().registrationDetails.vehicle
        let personalDetails = YBClient.sharedInstance().registrationDetails.personal
        
        vehicleDetails.inspectionFormPicture = self.vehicleInspFormFileId
        personalDetails.profilePicture = self.profilePictureFileId
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let fundingViewController = registerStoryboard.instantiateViewController(withIdentifier: "FundingInformationViewControllerIdentifier") as! FundingInformationViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(fundingViewController, animated: true)
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
                        self.profilePictureViewOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
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
                        self.vehicleInspFormOutlet.layer.borderColor = UIColor.appDarkGreen1().cgColor
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
