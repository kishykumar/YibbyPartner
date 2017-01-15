//
//  InsuranceViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CocoaLumberjack
import AIFlatSwitch

class InsuranceViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var uploadLicenseViewOutlet: YBUploadPictureView!
    @IBOutlet weak var uploadInsuranceViewOutlet: YBUploadPictureView!
    @IBOutlet weak var carOnInsuranceLabelOutlet: UILabel!
    
    @IBOutlet var insuranceExpirationTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var insuranceStateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    @IBOutlet weak var insuranceExpirationTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var insuranceStateTextFieldOutlet: YBPickerTextField!
    
    @IBOutlet weak var driverNameMatchSwitchOutlet: AIFlatSwitch!
    @IBOutlet weak var carOnInsuranceSwitchOutlet: AIFlatSwitch!
    
    var selectedInsuranceState: String?
    var selectedInsuranceExpDate: Date?
    
    private let MINIMUM_INSURANCE_EXPIRATION_MONTHS = 1
    
    // MARK: - Actions

    
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // conduct error checks
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let piViewController = registerStoryboard.instantiateViewController(withIdentifier: "PersonalInformationViewControllerIdentifier") as! PersonalInformationViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(piViewController, animated: true)
        
//        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @IBAction func onCarOnInsuranceClick(_ sender: AIFlatSwitch) {
        
    }
    
    @IBAction func onDriverNameMatchClick(_ sender: AIFlatSwitch) {
        
    }
    
    @IBAction func onInsuranceExpirationClick(_ sender: UITapGestureRecognizer) {
        
        DDLogVerbose("onInsuranceExpirationClick")
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        let datePicker = ActionSheetDatePicker(title: InterfaceString.ActionSheet.InsuranceExpirationDate, datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            if let date = value as? Date {
                self.selectedInsuranceExpDate = date
                
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.long
                self.insuranceExpirationTextFieldOutlet.text = formatter.string(from: date)
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: insuranceExpirationTextFieldOutlet);
        
        let minimumInsuranceExpDate = Calendar.current.date(byAdding: .month, value: MINIMUM_INSURANCE_EXPIRATION_MONTHS, to: Date())
        datePicker?.minimumDate = minimumInsuranceExpDate
        
        datePicker?.show()
    }
    
    @IBAction func onInsuranceStateClick(_ sender: UITapGestureRecognizer) {
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.InsuranceState, rows: InterfaceString.Resource.USStatesList, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let state = index as? String {
                self.selectedInsuranceState = state
                self.insuranceStateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: insuranceStateTextFieldOutlet)
    }
    
    // MARK: - Setup
    
    func setupUI () {
        self.uploadLicenseViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.License
        self.uploadInsuranceViewOutlet.uploadLabelOutlet.text = InterfaceString.Upload.Insurance
    }
    
    func setupDelegates() {
        
        self.insuranceExpirationTapGestureRecognizerOutlet.delegate = self
        self.insuranceStateTapGestureRecognizerOutlet.delegate = self
        
        self.insuranceExpirationTextFieldOutlet.delegate = self
        self.insuranceStateTextFieldOutlet.delegate = self
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
}

extension InsuranceViewController: UIGestureRecognizerDelegate {
    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension InsuranceViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DDLogVerbose("textFieldShouldBeginEditing")
        return false
    }
}
