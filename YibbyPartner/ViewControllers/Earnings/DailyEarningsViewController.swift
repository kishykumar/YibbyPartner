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

class DailyEarningsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var dayEarningsTableView: UITableView!

    let tripsSection: Int = 0
    
    let textCellIdentifier = "DayEarningsCellIdentifier"
    var selectedDate: Date!
    
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
        dayEarningsTableView.delegate = self
        dayEarningsTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)

        let tripDetailsViewController = earningsStoryboard.instantiateViewController(withIdentifier: "TripDetailsViewControllerIdentifier") as! TripDetailsViewController

        self.navigationController!.pushViewController(tripDetailsViewController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
//        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == tripsSection) {
            return InterfaceString.TableSections.Trips;
        }
        return ""
    }
    
    // MARK: Helper functions
    
    func afterViewLoadOps(_ sender: AnyObject) {
        loadEarningsData()
    }
    
    func loadEarningsData() {
        ActivityIndicatorUtil.enableActivityIndicator(self.view)
        fetchDailyEarningsDetails(selectedDate, successBlock: { () -> Void in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(3 * Int64(Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                ActivityIndicatorUtil.disableActivityIndicator(self.view)
            });
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
