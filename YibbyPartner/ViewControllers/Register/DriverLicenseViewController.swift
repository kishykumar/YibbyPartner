//
//  DriverLicenseViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CocoaLumberjack
import AIFlatSwitch

class DriverLicenseViewController: BaseYibbyViewController {

    // MARK: - Properties
    var usStates = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    @IBOutlet weak var firstNameTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var middleNameTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var lastNameTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var driverLicenseTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var stateTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var birthDateTextFieldOutlet: YBPickerTextField!
    
    @IBOutlet weak var commercialLicenseSwitchOutlet: AIFlatSwitch!
    
    @IBOutlet var stateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var birthDateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    var selectedState: String?
    var selectedBirthDate: Date?
    var isCommercialLicense: Bool?
    
    // MARK: - Actions
    
    
    @IBAction func onCommercialLicenseSwitchValueChange(_ sender: AIFlatSwitch) {
        isCommercialLicense = commercialLicenseSwitchOutlet.isSelected
    }
    
    @IBAction func onStateTextFieldClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.DriverLicenseState, rows: self.usStates, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let state = index as? String {
                self.selectedState = state
                self.stateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: stateTextFieldOutlet)
    }
    
    @IBAction func onBirthDateTextFieldClick(_ sender: UITapGestureRecognizer) {

        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        let datePicker = ActionSheetDatePicker(title: InterfaceString.ActionSheet.BirthDate, datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            if let date = value as? Date {
                self.selectedBirthDate = date
                
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.long
                self.birthDateTextFieldOutlet.text = formatter.string(from: date)
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: birthDateTextFieldOutlet);
        
        datePicker?.maximumDate = Date()
        
        datePicker?.show()
    }
    
    // MARK: - Setup
    
    func setupDelegates() {
        
        self.stateTapGestureRecognizerOutlet.delegate = self
        self.birthDateTapGestureRecognizerOutlet.delegate = self
        
        self.firstNameTextFieldOutlet.delegate = self
        self.middleNameTextFieldOutlet.delegate = self
        self.lastNameTextFieldOutlet.delegate = self
        self.driverLicenseTextFieldOutlet.delegate = self
        self.stateTextFieldOutlet.delegate = self
        self.birthDateTextFieldOutlet.delegate = self
    }
    
    func setupUI() {
        
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

extension DriverLicenseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DriverLicenseViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.firstNameTextFieldOutlet ||
            textField == self.middleNameTextFieldOutlet ||
            textField == self.lastNameTextFieldOutlet ||
            textField == self.driverLicenseTextFieldOutlet) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextFieldOutlet {
            
            middleNameTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == middleNameTextFieldOutlet {
            
            lastNameTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == lastNameTextFieldOutlet {
            
            driverLicenseTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == driverLicenseTextFieldOutlet {
            
            driverLicenseTextFieldOutlet.resignFirstResponder()
            return false
            
        }
        
        return true
    }
}
