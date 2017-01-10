//
//  VehicleViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class VehicleViewController: BaseYibbyViewController {

    // MARK: - Properties
    var vehicleYearsRange = [String]()
    var vehicleCapacityRange = ["3", "4", "5", "6", "7"]
    
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
    
    // MARK: - Actions
    
    @IBAction func vehicleMakeClicked(_ sender: UITapGestureRecognizer) {
        
        print("vehicleMakeClicked called")
    }
    
    @IBAction func onVehicleYearClick(_ sender: UITapGestureRecognizer) {
        
        print("onVehicleYearClick called")

        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleYear, rows: self.vehicleYearsRange, initialSelection: self.vehicleYearsRange.count - 1, doneBlock: {
            picker, value, index in
            
            self.vehicleYearTextFieldOutlet.text = index as? String
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: vehicleYearTextFieldOutlet)
    }
    
    @IBAction func onVehicleModelClick(_ sender: UITapGestureRecognizer) {
        print("onVehicleModelClick called")
        
    }
    
    @IBAction func onVehicleColorClick(_ sender: UITapGestureRecognizer) {
        print("onVehicleColorClick called")
        
    }
    
    @IBAction func onVehicleCapacityClick(_ sender: UITapGestureRecognizer) {
        print("onVehicleCapacityClick called")
        
        ActionSheetStringPicker.show(withTitle: InterfaceString.ActionSheet.VehicleYear, rows: self.vehicleCapacityRange, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print("onVehicleCapacityClick \(index)")
            self.vehicleCapacityTextFieldOutlet.text = index as? String
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
extension VehicleViewController: UIGestureRecognizerDelegate {
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
}
