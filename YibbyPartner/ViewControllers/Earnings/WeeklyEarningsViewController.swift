//
//  WeeklyEarningsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/14/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import BaasBoxSDK

class WeeklyEarningsViewController: BaseYibbyViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var dayEarningsTableViewOutlet: UITableView!
    @IBOutlet weak var bannerLabelOutlet: UILabel!

    var dateSelected: Date?
    var startOfTheWeek: Date!
    var endOfWeek: Date!

    let numberOfDaysInWeek = 7
    let DayEarningsTableCellIdentifier: String = "dayEarningsTableCellIdentifier"
    
    var dailyStats: [YBDayStat]?
    var dailyStatsMap: [Date: YBDayStat] = [:]

    // MARK: Actions
    
    
    // MARK: Setup functions
    
    func setupUI() {
        setupBackButton()

        let weekStartStr = TimeUtil.getDateStringInFormat(date: self.startOfTheWeek, format: "MM/dd")
        let weekEndStr = TimeUtil.getDateStringInFormat(date: self.endOfWeek, format: "MM/dd")
        
        self.bannerLabelOutlet.text = "\(weekStartStr) - \(weekEndStr) Detailed Earnings"
        
        // override the default background color
        self.view.backgroundColor = UIColor.white
    }

    func initProperties() {

    }

    func setupDelegates() {
        dayEarningsTableViewOutlet.delegate = self
        dayEarningsTableViewOutlet.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let dstats = self.dailyStats {
            for item in dstats {
                let date = TimeUtil.getDateFromString(dateStr: item.collectionDate!, format: "yyyy-MM-dd")
                dailyStatsMap[date!] = item
            }
        }
        
        initProperties()
        setupUI()
        setupDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfDaysInWeek;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DayEarningsTableCell = tableView.dequeueReusableCell(withIdentifier: DayEarningsTableCellIdentifier) as! DayEarningsTableCell
        cell.selectionStyle = .none
        
        let date: Date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: startOfTheWeek!)!
        var dayString = ""
        
        switch (indexPath.row) {
        case 0: dayString = "Sunday"
        case 1: dayString = "Monday"
        case 2: dayString = "Tuesday"
        case 3: dayString = "Wednesday"
        case 4: dayString = "Thursday"
        case 5: dayString = "Friday"
        case 6: dayString = "Saturday"
        default: assert(false)
        }

        let dateStr = TimeUtil.getDateStringInFormat(date: date, format: "MM/dd/yyyy")
        var earnings = "$0"
        var trips = "No trips"
        var onlineTime = "0 mins"
        
        DDLogVerbose("stat is : \(dailyStatsMap[date]) dump: ")
        dump(dailyStatsMap)
        
        if let stats: YBDayStat = dailyStatsMap[date] {
            earnings = String(format: "$%.02f", stats.earning!)
            
            if (stats.totalTrips != nil) {
                trips = "\(String(describing: stats.totalTrips!)) trips"
            }
            
            let totalOnlineTimeMins: Int = (stats.onlineTime! + 59) / 60
            onlineTime = "\(totalOnlineTimeMins) mins"
        }
        
        cell.configure(dayName: dayString, date: dateStr, earnings: earnings, totalTrips: trips, onlineTime: onlineTime)

        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let historyStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.History, bundle: nil)
        let historyController = historyStoryboard.instantiateViewController(withIdentifier: "HistoryViewControllerIdentifier") as! HistoryViewController
        
        let date: Date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: startOfTheWeek!)!
        historyController.selectedDate = date

        self.navigationController!.pushViewController(historyController, animated: true)
        
//        let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)
//
//        let dailyEarningsViewController = earningsStoryboard.instantiateViewController(withIdentifier: "DailyEarningsViewControllerIdentifier") as! DailyEarningsViewController
//
//            //+ indexPath.row
//
//        self.navigationController!.pushViewController(dailyEarningsViewController, animated: true)
    }
    
    // MARK: Helper functions

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
