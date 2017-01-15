//
//  DocumentUploadViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack

class DocumentUploadViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var profilePictureViewOutlet: YBUploadPictureView!
    @IBOutlet weak var vehicleInspFormOutlet: YBUploadPictureView!
    
    // MARK: - Actions
    
    @IBAction func onSubmitBarButtonClick(_ sender: UIBarButtonItem) {
        
        return;
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // conduct error checks
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let dlViewController = registerStoryboard.instantiateViewController(withIdentifier: "DriverLicenseViewControllerIdentifier") as! DriverLicenseViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(dlViewController, animated: true)
        
//        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: - Setup
    
    func setupUI () {
        self.profilePictureViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.ProfilePicture
        self.vehicleInspFormOutlet.uploadLabelOutlet.text = InterfaceString.Upload.VehicleInspectionForm
    }
    
    func setupDelegates() {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupDelegates()
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
