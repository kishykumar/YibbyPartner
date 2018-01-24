//
//  VehicleViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CocoaLumberjack
import SwiftValidator

class VehicleViewController: BaseYibbyViewController,
                             ValidationDelegate {

    // MARK: - Properties
    fileprivate var vehicleYearsRange: [String] = [String]()
    
    fileprivate var vehicleCapacityRange: [String] = ["3", "4", "5", "6", "7"]
    fileprivate var DEFAULT_VEHICLE_CAPACITY: String = "4"
    
    fileprivate var vehicleMakeRange: [String] = [String]()
    fileprivate var vehicleModelRange: [String] = [String]()
    
//    fileprivate var selectedYear: String?
//    fileprivate var selectedModel: String?
//    fileprivate var selectedColor: String?
//    fileprivate var selectedCapacity: String?
    fileprivate let validator: Validator = Validator()

    @IBOutlet var vehicleMakeTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var vehicleModelTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var vehicleYearTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var vehicleColorTapGestureRecognizerOutlet: UITapGestureRecognizer!
    @IBOutlet var vehicleCapacityTapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    @IBOutlet weak var vehicleYearTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var vehicleMakeTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var vehicleModelTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var vehicleColorTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var vehicleLicensePlateTextFieldOutlet: YBPickerTextField!
    @IBOutlet weak var vehicleCapacityTextFieldOutlet: YBPickerTextField!
    
    @IBOutlet weak var errorLabelOutlet: UILabel!
    
    let MINIMUM_VEHICLE_YEAR: String = "2001"
    
    let testMode: Bool = false
    
    // MARK: - Actions
    
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    @IBAction func vehicleMakeClicked(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        if (self.vehicleMakeRange.count == 0) {
            return;
        }
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleMake, rows: self.vehicleMakeRange, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            self.vehicleMakeTextFieldOutlet.text = (index as? String)!
            self.loadVehicleModels(make: self.vehicleMakeTextFieldOutlet.text!, year: self.vehicleYearTextFieldOutlet.text!)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleMakeTextFieldOutlet)
    }
    
    @IBAction func onVehicleYearClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleYear, rows: self.vehicleYearsRange, initialSelection: self.vehicleYearsRange.count - 1, doneBlock: {
            picker, value, index in

            if let year = index as? String {
                self.vehicleYearTextFieldOutlet.text = year
            
                self.loadVehicleMakes(year: self.vehicleYearTextFieldOutlet.text!)
            }

            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleYearTextFieldOutlet)
    }
    
    @IBAction func onVehicleModelClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        if (self.vehicleModelRange.count == 0) {
            return;
        }
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleModel, rows: self.vehicleModelRange, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let model = index as? String {
                self.vehicleModelTextFieldOutlet.text = model
                
                self.vehicleColorTextFieldOutlet.text = InterfaceString.Resource.VehicleColorsList.first
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleModelTextFieldOutlet)
    }
    
    @IBAction func onVehicleColorClick(_ sender: UITapGestureRecognizer) {

        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleColor, rows: InterfaceString.Resource.VehicleColorsList, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if let color = index as? String {
                self.vehicleColorTextFieldOutlet.text = color
                self.vehicleCapacityTextFieldOutlet.text = self.DEFAULT_VEHICLE_CAPACITY
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleModelTextFieldOutlet)
    }
    
    @IBAction func onVehicleCapacityClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleYear, rows: self.vehicleCapacityRange, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            if let capacity = index as? String {
                self.vehicleCapacityTextFieldOutlet.text = capacity
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleYearTextFieldOutlet)
    }
    
    // MARK: - Setup
    
    func setupDelegates() {
        
        self.vehicleMakeTapGestureRecognizerOutlet.delegate = self
        self.vehicleModelTapGestureRecognizerOutlet.delegate = self
        self.vehicleYearTapGestureRecognizerOutlet.delegate = self
        self.vehicleColorTapGestureRecognizerOutlet.delegate = self
        self.vehicleCapacityTapGestureRecognizerOutlet.delegate = self
        
        self.vehicleYearTextFieldOutlet.delegate = self
        self.vehicleMakeTextFieldOutlet.delegate = self
        self.vehicleModelTextFieldOutlet.delegate = self
        self.vehicleColorTextFieldOutlet.delegate = self
        self.vehicleCapacityTextFieldOutlet.delegate = self
        self.vehicleLicensePlateTextFieldOutlet.delegate = self
    }
    
    func setupUI() {
        
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // while nav bar tint
        self.navigationController?.navigationBar.tintColor = .white
        
        // green navigation bar color
        self.navigationController?.navigationBar.barTintColor = UIColor.appDarkGreen1()
        
        // title color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    func initProperties() {
        if (self.testMode) {
            self.vehicleYearTextFieldOutlet.text = "2014"
            self.vehicleMakeTextFieldOutlet.text = "Chevrolet"
            self.vehicleModelTextFieldOutlet.text = "Camaro"
            self.vehicleColorTextFieldOutlet.text = "Black"
            self.vehicleCapacityTextFieldOutlet.text = "4"
            self.vehicleLicensePlateTextFieldOutlet.text = "7KTU999"
        }
    }
    
    func setupActionSheets() {
    
        let calendar = NSCalendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy"
        
        let startDate = fmt.date(from: MINIMUM_VEHICLE_YEAR)
        
        var date = startDate! // first date
        let endDate = Date() // last date
        
        while date <= endDate {
            vehicleYearsRange.append(fmt.string(from: date))
            date = calendar.date(byAdding: .year, value: 1, to: date)!
        }
    }
    
    fileprivate func setupValidator() {
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.appDarkGreen1().cgColor
            }
        }, error:{ (validationError) -> Void in
            
            //            validationError.errorLabel?.isHidden = false
            //            validationError.errorLabel?.text = validationError.errorMessage
            //
            //            if let textField = validationError.field as? UITextField {
            //                textField.setBottomBorder(UIColor.red)
            //            }
        })
        
        validator.registerField(vehicleYearTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Vehicle Year is required")])
        validator.registerField(vehicleMakeTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Vehicle Make is required")])
        validator.registerField(vehicleModelTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Vehicle Model is required")])
        validator.registerField(vehicleColorTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Vehicle Color is required")])
        validator.registerField(vehicleLicensePlateTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "License Plate is required")])
        validator.registerField(vehicleCapacityTextFieldOutlet, errorLabel: errorLabelOutlet , rules: [RequiredRule(message: "Vehicle Capacity is required")])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
        setupDelegates()
        setupActionSheets()
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
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // on successful error checks, fill in the client registration data structure
        let clientVehicle = YBClient.sharedInstance().registrationDetails.vehicle
        clientVehicle.licensePlate = self.vehicleLicensePlateTextFieldOutlet.text
        clientVehicle.capacity = Int(self.vehicleCapacityTextFieldOutlet.text!)
        clientVehicle.year = Int(self.vehicleYearTextFieldOutlet.text!)
        clientVehicle.make = self.vehicleMakeTextFieldOutlet.text!
        clientVehicle.model = self.vehicleModelTextFieldOutlet.text!
        clientVehicle.exteriorColor = self.vehicleColorTextFieldOutlet.text!
        
        // Put the Activity on the right bar button item instead of Next Button
//        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        uiBusy.hidesWhenStopped = true
//        uiBusy.startAnimating()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let dlViewController = registerStoryboard.instantiateViewController(withIdentifier: "DriverLicenseViewControllerIdentifier") as! DriverLicenseViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(dlViewController, animated: true)
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        
        var errorDict: [UITextField:ValidationError] = [:]
        var errorTextField: UITextField = self.vehicleYearTextFieldOutlet
        var verror: ValidationError?
        
        // put the array elements in a dictionary
        for error in errors {
            
            let (_, validationError) = error
            
            if let textField = validationError.field as? UITextField {
                errorDict[textField] = validationError
            }
        }
        
        if let validationError = errorDict[self.vehicleYearTextFieldOutlet] {
            errorTextField = self.vehicleYearTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.vehicleMakeTextFieldOutlet] {
            errorTextField = self.vehicleMakeTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.vehicleModelTextFieldOutlet] {
            errorTextField = self.vehicleModelTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.vehicleColorTextFieldOutlet] {
            errorTextField = self.vehicleColorTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.vehicleLicensePlateTextFieldOutlet] {
            errorTextField = self.vehicleLicensePlateTextFieldOutlet
            verror = validationError
        } else if let validationError = errorDict[self.vehicleCapacityTextFieldOutlet] {
            errorTextField = self.vehicleCapacityTextFieldOutlet
            verror = validationError
        }
        
        verror!.errorLabel?.isHidden = false
        verror!.errorLabel?.text = verror!.errorMessage
        
        errorTextField.layer.borderColor = UIColor.red.cgColor
    }
    
    // MARK: - Helpers
    
    func loadVehicleMakes(year: String) {
        
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        
        VehicleDataAPI.sharedClient.getMakes(forYear: year, completion: { (_ makes: [VehicleMake]?, _ error: Error?) -> Void in
            
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
            
            if (error == nil) {
                self.vehicleMakeRange.removeAll()
                if let makesArr = makes {
                    for make in makesArr {
                        if let makeDisplay = make.makeDisplay {
                            self.vehicleMakeRange.append(makeDisplay)
                        }
                    }
                }
                
                self.vehicleMakeTextFieldOutlet.text = self.vehicleMakeRange.first
                self.loadVehicleModels(make: self.vehicleMakeTextFieldOutlet.text!, year: self.vehicleYearTextFieldOutlet.text!)

            } else {
                // TODO: show error alert
            }
        })
    }
    
    func loadVehicleModels(make: String, year: String) {
        
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        
        VehicleDataAPI.sharedClient.getModels(forMakeAndYear: make, year: year, completion: { (_ models: [VehicleModel]?, _ error: Error?) -> Void in
            
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
            
            if (error == nil) {
                self.vehicleModelRange.removeAll()
                if let modelsArr = models {
                    for model in modelsArr {
                        if let modelDisplay = model.modelName {
                            self.vehicleModelRange.append(modelDisplay)
                        }
                    }
                }
                
                // Initialize the model on a successful models fetch
                self.vehicleModelTextFieldOutlet.text = self.vehicleModelRange.first
                
            } else {
                // TODO: show error alert
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

extension VehicleViewController: UIGestureRecognizerDelegate {
    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension VehicleViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.vehicleLicensePlateTextFieldOutlet) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == vehicleLicensePlateTextFieldOutlet {
            vehicleLicensePlateTextFieldOutlet.resignFirstResponder()
            return false
        }
        
        return true
    }
}
