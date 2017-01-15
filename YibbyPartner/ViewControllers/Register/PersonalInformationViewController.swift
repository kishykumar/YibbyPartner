//
//  PersonalInformationViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CocoaLumberjack
import AIFlatSwitch

class PersonalInformationViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var ssnTextFieldOutlet: YBLeftImageTextField!
    @IBOutlet weak var emailTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var streetAddressTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var cityTextFieldOutlet: YBFloatLabelTextField!
    @IBOutlet weak var stateTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var zipcodeTextFieldOutlet: YBFloatLabelTextField!
    
    @IBOutlet var stateTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    var selectedState: String?
    
    // MARK: - Actions
    
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // conduct error checks
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let consentViewController = registerStoryboard.instantiateViewController(withIdentifier: "ConsentViewControllerIdentifier") as! ConsentViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(consentViewController, animated: true)
        
//        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @IBAction func onStateClick(_ sender: UITapGestureRecognizer) {
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.AddressState, rows: InterfaceString.Resource.USStatesList, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let state = index as? String {
                self.selectedState = state
                self.stateTextFieldOutlet.text = state
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: stateTextFieldOutlet)
    }
    
    // MARK: - Setup
    
    func setupUI () {
        
    }
    
    func setupDelegates() {
        
        self.stateTapGestureRecognizerOutlet.delegate = self
        
        self.ssnTextFieldOutlet.delegate = self
        self.emailTextFieldOutlet.delegate = self
        self.streetAddressTextFieldOutlet.delegate = self
        self.cityTextFieldOutlet.delegate = self
        self.stateTextFieldOutlet.delegate = self
        self.zipcodeTextFieldOutlet.delegate = self
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

extension PersonalInformationViewController: UIGestureRecognizerDelegate {
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension PersonalInformationViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.ssnTextFieldOutlet ||
            textField == self.emailTextFieldOutlet ||
            textField == self.streetAddressTextFieldOutlet ||
            textField == self.zipcodeTextFieldOutlet ||
            textField == self.cityTextFieldOutlet) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == ssnTextFieldOutlet {
            
            emailTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == emailTextFieldOutlet {
            
            streetAddressTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == streetAddressTextFieldOutlet {
            
            cityTextFieldOutlet.becomeFirstResponder()
            return false
            
        } else if textField == cityTextFieldOutlet {
            
            cityTextFieldOutlet.resignFirstResponder()
            return false
            
        }
        
        return true
    }
}
