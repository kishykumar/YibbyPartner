//
//  DestinationPickerViewController.swift
//  Example
//
//  Created by Kishy Kumar on 1/18/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import GoogleMaps

protocol DestinationDelegate {
    func choseDestination(location: String)
}

class DestinationPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupMapClient () {
        placesClient = GMSPlacesClient()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    // MARK: actions
    @IBAction func sendBack(sender: UIButton) {
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
