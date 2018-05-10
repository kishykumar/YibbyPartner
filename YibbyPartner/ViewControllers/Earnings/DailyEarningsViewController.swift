//
//  DailyEarningsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/12/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import BaasBoxSDK

public typealias FetchDailyEarningsSuccessBlock = () -> Void

class DailyEarningsViewController: BaseYibbyViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var tripsTableView: UITableView!
    
    let TripEarningsTableViewCellIdentifier: String = "tripEarningsTableViewCellIdentifier"
    var selectedDate: Date!
    
    var totalTrips = 0
    var ridesList: [Ride] = [Ride]()

    // MARK: Actions
    
    
    // MARK: Setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
        self.perform(#selector(afterViewLoadOps), with: nil, afterDelay: 0.0)
    }
    
    func initProperties() {
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        setupBackButton()
        
        // override the default background color
        self.view.backgroundColor = UIColor.white
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let historyStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.History, bundle: nil)

        let tripDetailsViewController = historyStoryboard.instantiateViewController(withIdentifier: "RideDetailViewControllerIdentifier") as! RideDetailViewController

        tripDetailsViewController.ride = ridesList[indexPath.row]

        self.navigationController!.pushViewController(tripDetailsViewController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TripEarningsTableViewCellIdentifier, for: indexPath)
        
//        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalTrips;
    }
    
    // MARK: Helper functions
    
    @objc func afterViewLoadOps(_ sender: AnyObject) {
        loadEarningsData()
    }
    
    func loadEarningsData() {
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        fetchDailyEarningsDetails(selectedDate, successBlock: { () -> Void in
            ActivityIndicatorUtil.disableActivityIndicator(self.view)
        })
    }
    
    func fetchDailyEarningsDetails(_ day: Date, successBlock: @escaping FetchDailyEarningsSuccessBlock) {
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                
                client.dummyCall( {(success, error) -> Void in
                    
                    //                    if (error == nil) {
                    successBlock()
                    //                    }
                    //                    else {
                    //                        errorBlock(success, error)
                    //                    }
                })
        })
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
