//
//  DocumentsTableViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 10/15/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import Lightbox
import BaasBoxSDK

class DocumentsTableViewController: UITableViewController {

    // MARK: - Properties
    
    var imagesMap: [Int: LightboxImage] = [Int: LightboxImage]()

    fileprivate enum TableRows: Int {
        case driverLicense = 0
        case insurance
        case vehicleInspection
    }
    
    // MARK: - Actions
    
    
    // MARK: - Setup
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    //MARK: - UITableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)        

        if (imagesMap[indexPath.row] == nil) {
            
            switch (indexPath.row) {
            case TableRows.driverLicense.rawValue:
                
                if let driverLicenseFileId = YBClient.sharedInstance().profile?.driverLicense?.licensePicture {
                    if (driverLicenseFileId != "") {
                        if let imageUrl  = BAAFile.getCompleteURL(withToken: driverLicenseFileId) {
                            imagesMap[indexPath.row] = LightboxImage(imageURL: imageUrl)
                        }
                    }
                }
                
                break
            
            case TableRows.insurance.rawValue:
                
                if let insuranceFileId = YBClient.sharedInstance().profile?.insurance?.insuranceCardPicture {
                    if (insuranceFileId != "") {
                        if let imageUrl  = BAAFile.getCompleteURL(withToken: insuranceFileId) {
                            imagesMap[indexPath.row] = LightboxImage(imageURL: imageUrl)
                        }
                    }
                }
                
                break
                
            case TableRows.vehicleInspection.rawValue:
                
                if let vehicleInspectionFileId = YBClient.sharedInstance().profile?.vehicle?.inspectionFormPicture {
                    if (vehicleInspectionFileId != "") {
                        if let imageUrl  = BAAFile.getCompleteURL(withToken: vehicleInspectionFileId) {
                            imagesMap[indexPath.row] = LightboxImage(imageURL: imageUrl)
                        }
                    }
                }
                
                break
                
            default:
                break
            }
        }
        
        let imagesArray: [LightboxImage] = [imagesMap[indexPath.row]!]
        
        // Create an instance of LightboxController.
        let controller = LightboxController(images: imagesArray)
        
        // Set delegates.
        //controller.pageDelegate = self
        //controller.dismissalDelegate = self
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }

    
    // MARK: - Helpers
}
