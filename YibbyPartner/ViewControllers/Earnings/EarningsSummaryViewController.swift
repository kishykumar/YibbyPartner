//
//  EarningsSummaryViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/9/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import JTCalendar
import CocoaLumberjack
import BaasBoxSDK
import ObjectMapper

public typealias FetchEarningsSuccessBlock = () -> Void

class EarningsSummaryViewController: BaseYibbyViewController, JTCalendarDelegate {

    // MARK: Properties
    
    @IBOutlet weak var calendarMenuOutlet: JTCalendarMenuView!
    @IBOutlet weak var calendarOutlet: JTHorizontalCalendarView!
    @IBOutlet weak var summaryEarningsOutlet: UIView!
    @IBOutlet weak var weekLabelOutlet: UILabel!
    @IBOutlet weak var totalPayoutLabelOutlet: UILabel!
    @IBOutlet weak var completedTripsLabelOutlet: UILabel!
    @IBOutlet weak var timeOnlineLabelOutlet: UILabel!

    var calendarManager: JTCalendarManager!
    var dateSelected: Date?
    var startOfTheWeek: Date?
    var endOfWeek: Date?

    var dailyStats: [YBDayStat]?
    
    // MARK: Actions

    @IBAction func viewDetailedEarningsActions(_ sender: UIButton) {
        let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)

        let weeklyEarningsViewController = earningsStoryboard.instantiateViewController(withIdentifier: "WeeklyEarningsViewControllerIdentifier") as! WeeklyEarningsViewController

        weeklyEarningsViewController.startOfTheWeek = self.startOfTheWeek
        weeklyEarningsViewController.endOfWeek = self.endOfWeek
        weeklyEarningsViewController.dailyStats = self.dailyStats
        
        self.navigationController!.pushViewController(weeklyEarningsViewController, animated: true)
    }

    // MARK: Setup functions
    
    func setupUI() {
        setupBackButton()
        
        calendarOutlet.layer.borderWidth = 1.0
        calendarOutlet.layer.borderColor = UIColor.gray.cgColor
        
        // override the default background color
        self.view.backgroundColor = UIColor.white
    }

    func initProperties() {
        
    }

    func setupCalendar() {
        
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        self.calendarManager.menuView = calendarMenuOutlet
        self.calendarManager.contentView = calendarOutlet
        self.calendarManager.setDate(Date())
        
        var calendar = self.calendarManager.dateHelper.calendar()
        calendar!.locale = Locale(identifier: "en_US")
        calendar!.timeZone = TimeZone.init(abbreviation: "PDT")!
        calendar!.firstWeekday = 4 // Wednesday
        
        computeStartEndWeek(Date())
        self.perform(#selector(EarningsSummaryViewController.fetchEarningsCurrentWeek), with:nil, afterDelay:0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
        setupCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: JTCalendarDelegate

    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {

        dayView.isHidden = false
        
        if let dayView = dayView as? JTCalendarDayView {
            // Test if the dayView is from another month than the page
            // Use only in month mode for indicate the day of the previous or next month
            
            // Selected week
            if (self.startOfTheWeek != nil && self.endOfWeek != nil &&
                calendarManager.dateHelper.date(dayView.date, isEqualOrAfter: self.startOfTheWeek!, andEqualOrBefore: self.endOfWeek!)) {
                dayView.circleView.isHidden = true
                //dayView.circleView.backgroundColor = UIColor.red
                dayView.dotView.backgroundColor = UIColor.white
                dayView.textLabel.textColor = UIColor.appDarkGreen1()
                dayView.textLabel.font = UIFont(name: "Avenir-Black", size: 20)
            }
            // Other month
            else if dayView.isFromAnotherMonth {
                dayView.circleView.isHidden = true
                dayView.dotView.backgroundColor = UIColor.red
                dayView.textLabel.textColor = UIColor.lightGray
                dayView.textLabel.font = UIFont(name: "Avenir-Light", size: 16)
            }
            // Today
            else if calendarManager.dateHelper.date(Date(), isTheSameDayThan: dayView.date) {
                dayView.circleView.isHidden = true
                //dayView.circleView.backgroundColor = UIColor.blue
                dayView.dotView.backgroundColor = UIColor.blue
                dayView.textLabel.textColor = UIColor.black
                dayView.textLabel.font = UIFont(name: "Avenir-Light", size: 16)
            }
            // Selected Day
            else if ((self.dateSelected != nil) &&
                        calendarManager.dateHelper.date(self.dateSelected, isTheSameDayThan: dayView.date)) {
                dayView.circleView.isHidden = false
                dayView.circleView.backgroundColor = UIColor.red
                dayView.dotView.backgroundColor = UIColor.white
                dayView.textLabel.textColor = UIColor.white
                dayView.textLabel.font = UIFont(name: "Avenir-Light", size: 16)
            }
            // Another day of the current month
            else {
                dayView.circleView.isHidden = true
                dayView.dotView.backgroundColor = UIColor.red
                dayView.textLabel.textColor = UIColor.black
                dayView.textLabel.font = UIFont(name: "Avenir-Light", size: 16)
            }
            
            // Your method to test if a date have an event for example
//            if self.haveEventForDay(dayView.date) {
//                dayView.dotView.hidden = false
//            }
//            else {
//                dayView.dotView.hidden = true
//            }
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {

        var dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = calendarManager.dateHelper.calendar().locale
        dateFormatter.timeZone = calendarManager.dateHelper.calendar().timeZone

        (menuItemView as? UILabel)!.text = dateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: JTCalendarManager, didTouchDayView dayView: UIView!) {
        
        if let dayView = dayView as? JTCalendarDayView {

            self.dateSelected = dayView.date
            
            computeStartEndWeek(dayView.date)
            
            // Animation for the circleView
            dayView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            
            UIView.transition(with: dayView, duration: 0.3, options: [], animations: {() -> Void in
                dayView.circleView.transform = CGAffineTransform.identity
                self.fetchEarningsCurrentWeek()
                
            }, completion: { _ in })
            
            // Don't change page in week mode because block the selection of days in first and last weeks of the month
//            if calendarManager.settings.weekModeEnabled {
//                return
//            }
            
            // Load the previous or next page if touch a day from another month
//            if !calendarManager.dateHelper.date(calendarOutlet.date, isTheSameMonthThan: dayView.date) {
//                if calendarOutlet.date.compare(dayView.date) == .OrderedDescending {
//                    calendarOutlet.loadNextPageWithAnimation()
//                }
//                else {
//                    calendarOutlet.loadPreviousPageWithAnimation()
//                }
//            }
        }
    }

    func calendarBuildDayView(_ calendar: JTCalendarManager!) -> UIView! {
        let view: JTCalendarDayView = JTCalendarDayView()
        
        //view.textLabel.font = UIFont(name: "Avenir-Light", size: 16)
        //view.circleRatio = 2
        //view.dotRatio = 1.0 / 0.9
        
        view.textLabel.layer.borderWidth = 1.0
        view.textLabel.layer.borderColor = UIColor.greyE5().cgColor
        
        return view
    }
    
    // MARK: Helpers
    
    @objc fileprivate func fetchEarningsCurrentWeek() {
        
        let weekStart = self.startOfTheWeek!
        let endOfWeek = self.endOfWeek!
        
        fetchWeeklyEarnings(weekStart, endOfWeek: endOfWeek,  successBlock: {() -> Void in
            
            let weekStartStr = TimeUtil.getDateStringInFormat(date: weekStart, format: "MM/dd")
            let weekEndStr = TimeUtil.getDateStringInFormat(date: endOfWeek, format: "MM/dd")
            self.weekLabelOutlet.text = "\(weekStartStr) - \(weekEndStr)"
            
            self.calendarManager.reload()
        })
    }
    
    func fetchWeeklyEarnings(_ weekStart: Date, endOfWeek: Date, successBlock: @escaping FetchEarningsSuccessBlock) {
        
        let weekStartStr = TimeUtil.getDateStringInFormat(date: weekStart, format: "yyyy-MM-dd")
        let weekEndStr = TimeUtil.getDateStringInFormat(date: endOfWeek, format: "yyyy-MM-dd")
        
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: @escaping (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.shared()
                
                client.getDriverStats(weekStartStr, endDate: weekEndStr, completion: {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                        if (error == nil) {
                            
                            // success has the data
                            let statsModel = Mapper<YBDriverStats>().map(JSONObject: success)!

                            self.dailyStats = statsModel.daily
                            
                            if let weeklyStats: YBWeekStat = statsModel.week {
                                
                                if let earning = weeklyStats.earning {
                                    self.totalPayoutLabelOutlet.text = String(format: "$%.02f", earning)
                                }
                                
                                if let rides = weeklyStats.rides {
                                    self.completedTripsLabelOutlet.text = String(rides)
                                }
                                
                                if let onlineTime = weeklyStats.onlineTime {
                                    self.timeOnlineLabelOutlet.text = "\(String(onlineTime)) mins"
                                }
                            }
                            
                            successBlock()
                        }
                        else {
                            // print error
                            DDLogError("ERROR in fetchWeeklyEarnings: \(error.debugDescription)")
                            errorBlock(success, error)
                        }
                })
        })
    }
    
    func computeStartEndWeek(_ inDate: Date) {
//        let calendar = calendarManager.dateHelper.calendar()
        var interval = TimeInterval(0)
        
        var date: Date = Date()
        Calendar.current.dateInterval(of: .weekOfMonth, start: &date, interval: &interval, for: inDate)
        
        self.startOfTheWeek = date
        self.endOfWeek = self.startOfTheWeek!.addingTimeInterval(interval - 1)
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

