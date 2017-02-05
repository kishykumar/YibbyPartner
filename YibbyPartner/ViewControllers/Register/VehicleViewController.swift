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

class VehicleViewController: BaseYibbyViewController {

    // MARK: - Properties
    var vehicleYearsRange = [String]()
    
    var vehicleCapacityRange = ["3", "4", "5", "6", "7"]
    var DEFAULT_VEHICLE_CAPACITY = "4"
    
    var vehicleMakeRange = [String]()
    var vehicleModelRange = [String]()
    
    var selectedYear: String?
    var selectedMake: String?
    var selectedModel: String?
    var selectedColor: String?
    var selectedCapacity: String?
    var licensePlateNumber: String?
    
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
    
    let MINIMUM_VEHICLE_YEAR = "2001"
    
    let testMode = true
    
    // MARK: - Actions
    
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()

        // TODO: conduct error checks
        
        
        // on successful error checks, fill in the client registration data structure
        let clientVehicle = YBClient.sharedInstance().registrationDetails.vehicle
        clientVehicle.licensePlate = licensePlateNumber
        clientVehicle.capacity = Int(selectedCapacity!)
        clientVehicle.year = Int(selectedYear!)
        clientVehicle.make = selectedMake
        clientVehicle.model = selectedModel
        clientVehicle.exteriorColor = selectedColor
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let dlViewController = registerStoryboard.instantiateViewController(withIdentifier: "DriverLicenseViewControllerIdentifier") as! DriverLicenseViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(dlViewController, animated: true)
    }
    
    @IBAction func vehicleMakeClicked(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        if (self.vehicleMakeRange.count == 0) {
            return;
        }
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleMake, rows: self.vehicleMakeRange, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            self.selectedMake = (index as? String)!
            self.vehicleMakeTextFieldOutlet.text = self.selectedMake
            
            self.loadVehicleModels(make: self.selectedMake!, year: self.selectedYear!)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleMakeTextFieldOutlet)
    }
    
    @IBAction func onVehicleYearClick(_ sender: UITapGestureRecognizer) {
        
        // dismiss the keyboard if it's visible
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleYear, rows: self.vehicleYearsRange, initialSelection: self.vehicleYearsRange.count - 1, doneBlock: {
            picker, value, index in

            if let year = index as? String {
                self.selectedYear = year
                self.vehicleYearTextFieldOutlet.text = year
            
                self.loadVehicleMakes(year: self.selectedYear!)
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
                self.selectedModel = model
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
                self.selectedColor = color
                self.vehicleColorTextFieldOutlet.text = color
                
                self.vehicleCapacityTextFieldOutlet.text = self.DEFAULT_VEHICLE_CAPACITY
                self.selectedCapacity = self.DEFAULT_VEHICLE_CAPACITY
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
                self.selectedCapacity = capacity
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
    }

    func initProperties() {
        if (self.testMode) {
            selectedYear = "2014"
            selectedMake = "Chevrolet"
            selectedModel = "Camaro"
            selectedColor = "Black"
            selectedCapacity = "4"
            licensePlateNumber = "KTU7083"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupDelegates()
        setupActionSheets()
        initProperties()
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
