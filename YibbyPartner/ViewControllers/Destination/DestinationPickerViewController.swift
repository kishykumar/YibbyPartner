//
//  DestinationPickerViewController.swift
//  Example
//
//  Created by Kishy Kumar on 1/18/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CocoaLumberjack

protocol DestinationDelegate {
    func choseDestination(_ location: String)
}

class DestinationPickerViewController: BaseYibbyViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var delegate : DestinationDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    var items: [String] = ["We", "Heart", "Swift"]
    
//    var destinations = [Destination]()
    var placesClient: GMSPlacesClient?
    
    // MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMapClient()
        
        // Register the call class. If a custom class is created, this code will most likely be removed and you can fill in the ReUseCellIdentifier in Storyboard
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupMapClient () {
        placesClient = GMSPlacesClient()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    // MARK: actions
    @IBAction func sendBack(_ sender: UIButton) {
        delegate!.choseDestination("My name is Kishy");
        
        
        // save the presenting ViewController
//        let presentingViewController :UIViewController! = self.presentingViewController;
//        dismissViewControllerAnimated(true, completion: nil)
//        self.dismissViewControllerAnimated(false)
            // go back to MainMenuView as the eyes of the user
//            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
