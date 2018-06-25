//
//  HistoryViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 4/5/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit
import CocoaLumberjack
import BaasBoxSDK
import DZNEmptyDataSet
import MBProgressHUD
import Braintree
import ObjectMapper
import GoogleMaps

class HistoryViewController: BaseYibbyTableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {

    // MARK - Properties

    let identifier: String = "historyTableCell"

    var ridesList: [Ride] = [Ride]()
    
    var shownRides: Int = 0
    var totalRides: Int = 0
    var nextPageToLoad: Int = 0
    var totalPages: Int = 0
    var isLoading: Bool = false

    var selectedDate: Date?
    
    // MARK - Setup

    let NUM_FETCH_RIDE_ENTRIES: Int = 5
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // Do any additional setup after loading the view.
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        // A little trick for removing the cell separators. 
        // EDIT: This has been done in IB itself.
        // self.tableView.tableFooterView = UIView()
        
        //This block runs when the table view scrolled to the bottom
        weak var weakSelf = self

        //Don't forget to make weak pointer to self
        self.tableScrolledDownBlock = { () -> Void in
            
            // data loading logic
            if let strongSelf = weakSelf {
                if !strongSelf.isLoading {
                    strongSelf.loadNextPage()
                }
            }
        }
        
        self.shownRides = 0
        self.totalRides = 0
        self.nextPageToLoad = 0
        self.totalPages = 0
    }
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    func setupUI() {
        setupBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HistoryTableCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HistoryTableCell
        
        let ride = self.ridesList[indexPath.row]

        //let myride = YBClient.sharedInstance().fakeRide
        cell.configure(ride)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shownRides
    }
    
    //MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let historyStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.History, bundle: nil)
        let rideDetailViewController = historyStoryboard.instantiateViewController(withIdentifier: "RideDetailViewControllerIdentifier") as! RideDetailViewController
        rideDetailViewController.ride = ridesList[indexPath.row]

        self.navigationController?.pushViewController(rideDetailViewController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.shownRides == 0) {
            return 0;
        }
        
        // Return the number of sections.
        return 1;
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rideDetail" {
            let indexPath = self.tableView!.indexPathForSelectedRow
            let destinationViewController: RideDetailViewController = segue.destination as! RideDetailViewController
            
            destinationViewController.ride = ridesList[indexPath!.row]
        }
    }
    
    // MARK: DZNEmptyDataSet Delegate-Datasource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if (self.isLoading) {
            return nil;
        }
        
        let attrs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22.0), NSAttributedStringKey.foregroundColor: UIColor.appDarkGreen1()]
        return NSAttributedString(string: InterfaceString.EmptyDataMsg.NotRiddenYetTitle, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if (self.isLoading) {
            return nil;
        }
        
        let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0), NSAttributedStringKey.foregroundColor: UIColor.black]
        return NSAttributedString(string: InterfaceString.EmptyDataMsg.NotRiddenYetDescription, attributes: attrs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let defaultColor: UIColor = self.view.tintColor
        let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0), NSAttributedStringKey.foregroundColor: defaultColor]
        return NSAttributedString(string: "Learn More", attributes: attrs)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20.0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        if (self.isLoading) {
            return nil;
        }
        
        return UIImage(named: "car_gear")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        // TODO:
        let url = URL(string: "http://yibbyapp.com")!
        UIApplication.shared.openURL(url)
    }
    
    // MARK: - Helpers
    
    fileprivate func reinit() {
        
        if (self.shownRides != 0) {
            let topInset: CGFloat = 100
            self.tableView.contentInset =  UIEdgeInsetsMake(topInset, 0, 0, 0);
        }
        
        self.tableView.reloadData()
    }
    
    @objc fileprivate func loadNextPage() {
        self.isLoading = true

        if (self.footerActivityIndicatorView() == nil &&
            nextPageToLoad != 0) {
            self.addFooterActivityIndicator(withHeight: 80.0)
        }
        
        // Make nested webserver calls to get
        //   1. the total number of rides,  and
        //   2. the first page of rides
        if nextPageToLoad == 0 {
            
            ActivityIndicatorUtil.enableBlurActivityIndicator(self.view, title: InterfaceString.ActivityIndicator.Loading)
            
            WebInterface.makeWebRequestAndHandleError(
                self,
                webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                    
                    var dateStr: String?
                    if let date = selectedDate {
                        dateStr = TimeUtil.getDateStringInFormat(date: date, format: "yyyy-MM-dd")
                    }
                    
                    let client: BAAClient = BAAClient.shared()
                    client.fetchCount(forRides: dateStr, completion: {(success, error) -> Void in
                        
                        if (error == nil) {
                            
                            // parse the result to get the total number of rides
                            DDLogVerbose("Success in fetching ridecount: \(success)")
                            self.totalRides = success
                            
                            // If zero total rides, then return and remove the activity indicator
                            if self.totalRides == 0 {
                                
                                // The DNZ Empty container view will be shown automatically
                                ActivityIndicatorUtil.disableActivityIndicator(self.view)
                                
                                if (self.footerActivityIndicatorView() != nil) {
                                    self.removeFooterActivityIndicator()
                                }
                                
                                self.isLoading = false
                                self.reinit()
                                return;
                            }
                            
                            self.perform(#selector(HistoryViewController.loadNewRides),
                                         with:nil, afterDelay:1.0)
                        }
                        else {
                            errorBlock(success, error)
                            
                            // The DNZ Empty container view will be shown automatically
                            ActivityIndicatorUtil.disableActivityIndicator(self.view)
                            
                            if (self.footerActivityIndicatorView() != nil) {
                                self.removeFooterActivityIndicator()
                            }
                            
                            self.isLoading = false
                            self.reinit()
                            return;
                        }
                    })
            })
            
            return;
        }
        
        // Add ENFooterActivityIndicatorView to tableView's footer
        if shownRides < totalRides {
            self.perform(#selector(HistoryViewController.loadNewRides), with:nil, afterDelay:5.0)
        }
        else {
            if (self.footerActivityIndicatorView() != nil) {
                self.removeFooterActivityIndicator()
            }
        }
    }
    
    @objc fileprivate func loadNewRides() {
        
        // load the new rides
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                let client: BAAClient = BAAClient.shared()
                
                var parameters: [String : Any] = ["orderBy": "_creation_date desc", "recordsPerPage": self.NUM_FETCH_RIDE_ENTRIES,
                                                  "page": self.nextPageToLoad]
                
                if let date = selectedDate {
                    let dateStr = TimeUtil.getDateStringInFormat(date: date, format: "yyyy-MM-dd")
                    parameters["where"] = "_creation_date.format('yyyy-MM-dd')='\(dateStr)'"
                }
                
                client.getRides(BAASBOX_RIDER_STRING,
                    withParams: parameters,
                    completion: {(success, error) -> Void in
                        
                        if (error == nil && success != nil) {
                            
                            let loadedRides = Mapper<Ride>().mapArray(JSONObject: success)
                            
                            if let loadedRides = loadedRides {
                                
                                let numRidesToShow = loadedRides.count
                                
                                if numRidesToShow != 0 {
                                    // add the new rides to the existing set of rides
                                    for i in 0...(numRidesToShow-1) {
                                        self.ridesList.append(loadedRides[i])
                                    }
                                    
                                    self.shownRides = (self.shownRides + numRidesToShow)
                                    self.nextPageToLoad = self.nextPageToLoad + 1
                                    
                                    self.reinit()
                                }
                            }
                        }
                        else {
                            errorBlock(success, error)
                        }
                        
                        ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        
                        if (self.footerActivityIndicatorView() != nil) {
                            self.removeFooterActivityIndicator()
                        }
                        
                        self.isLoading = false
                })
        })
    }

}
